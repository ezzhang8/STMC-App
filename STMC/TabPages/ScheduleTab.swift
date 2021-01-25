//
//  ScheduleTab.swift
//  STMC
//
//  Created by Eric Zhang on 2019-11-24.
//  Copyright © 2019 Eric Zhang. All rights reserved.
//

import Combine
import SwiftUI
import SwiftyJSON

struct ScheduleTab: View {
    @EnvironmentObject var userStatus: Profile
    @State var showingCalendar = false
    @StateObject private var ScheduleArray = Schedules()
    @State private var isShowing = false

    var body: some View {
        NavigationView {
            ScrollView {
                Divider()
                VStack(alignment: .leading) {
                    Section (header:
                        HStack {
                            Image(systemName: "arrow.right.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(determineInitialLabelText(schedule: ScheduleArray.data))
                                .font(.title3)
                                .fontWeight(.bold)

                        }
                        .padding(.leading)
                    ){
                        if (ScheduleArray.data.count == 0) {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 50, height: 50)
                                Spacer()

                            }
                        }
                        ForEach(Array(ScheduleArray.data.enumerated()), id: \.element) { index, schedule in
                            if index == 0 {
                                ScheduleCard(schedule: schedule, seniority: determineSeniority(userStatus: userStatus))
                            }
                        }
                        .onAppear {
                            ScheduleArray.override()
                        }
                }
                .padding(.top, 2.0)
                Divider()
                Section (header:
                    HStack {
                        Image(systemName: "clock")
                            .resizable()	
                            .frame(width: 20, height: 20)
                        Text("Upcoming")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                            
                    }
                    .padding(.leading)
                ){
                    VStack (alignment: .leading) {
                        if (ScheduleArray.data.count == 0) {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 50, height: 50)
                                Spacer()
                            }
                        }
                        ForEach(0..<ScheduleArray.data.count, id: \.self) { index in
                            if index > 0 {
                                ScheduleCard(schedule: ScheduleArray.data[index], seniority: determineSeniority(userStatus: userStatus))
                            }
                        }
                        
                        Spacer()
                    }
                    .onAppear {
                        ScheduleArray.override()
                    }

                }
            }
            .navigationBarTitle(Text("Schedule"))
            .navigationBarItems(leading:
                Button(action:{
                    self.showingCalendar.toggle()
                }) {
                    Image(systemName: "calendar.circle")
                        .resizable()
                        .accentColor(.STMC)
                        .frame(width: 25, height: 25)
                }
                .frame(width: 25, height: 45)
                .sheet(isPresented: $showingCalendar) {
                    CalendarView()
                })
            }
            .background(Color.GR.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .onAppear {
                if (ScheduleArray.cacheDate() == false) {
                    ScheduleArray.load()
                }
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if (ScheduleArray.cacheDate() == false) {
                ScheduleArray.load()
            }
        }
    }
}

func determineInitialLabelText(schedule: [Schedule]) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    
    let date = Date()
    
    if schedule.count > 0 && schedule[0].startDate == dateFormatter.string(from: date) {
        return "Today"
    }
    else {
        return "Next"
    }
}


private class Schedules: ObservableObject {
    @Published var data = [Schedule]()
        
    let UD = UserDefaults.standard
    var scheduleData = [Schedule]()
    init() {
//        DispatchQueue.main.async {
//            self.data = [Schedule]()
//            self.scheduleData = [Schedule]()
//        }
        self.load()
    }
    
    func override() {
        sendRequest(url: String(API.url+"overrides/"), completion: { json in
            let error = json["error"].string

            if error != nil {
                return
            }
            
            let array = json.array!
            
            for day in array {
                let date = day["date"].stringValue
                let blockRotation = day["blockRotation"].stringValue
                let scheduleType = day["scheduleType"].stringValue
                let scheduleFamily = day["scheduleFamily"].stringValue
                let index = self.data.firstIndex{$0.startDate == date}
                
                DispatchQueue.main.async {
                    if index != nil {
                        let id = self.data[index!].id
                        let dotw = self.data[index!].dotw
                        
                        self.data[index!] = Schedule(id: id, summary: blockRotation, dotw: dotw, startDate: date, scheduleType: scheduleType, scheduleFamily: scheduleFamily)
                        if let cachedArray = try? PropertyListEncoder().encode(self.data) {
                            self.UD.set(cachedArray, forKey: "ScheduleData")
                        }
                    }
                }
                
            }
            
        })
        
    }
    func load() {
//        DispatchQueue.main.async {
//            self.data = [Schedule]()
//            self.scheduleData = [Schedule]()
//
//        }
        sendRequest(url: API.calendar, completion: { json in
            let error = json["error"].string

            if error != nil {
                self.loadEventsFromCache()
                return
            }
            let items = json["items"].array!
            
            UserDefaults.standard.removeObject(forKey: "ScheduleData")

            for item in items {
                let summary = item["summary"].stringValue
                let id = item["id"].stringValue
                let startDate = item["start"]["date"].string
                                
                if startDate != nil && summary.hasPrefix("MORE - ") || summary.hasPrefix("RICE - ") {
                    var dotw: String
                    
                    let scheduleComponents = summary.components(separatedBy: " - ")
                    dotw = self.dayFromDateString(dateString: startDate!)
                    
                    if scheduleComponents.count > 2 {
                        self.scheduleData.append(Schedule(id: id, summary: scheduleComponents[1], dotw: dotw, startDate: startDate!, scheduleType: scheduleComponents[2], scheduleFamily: scheduleComponents[0]))
                    }
                    else {
                        self.scheduleData.append(Schedule(id: id, summary: scheduleComponents[1], dotw: dotw, startDate: startDate!, scheduleType: "Regular Schedule", scheduleFamily: scheduleComponents[0]))
                    }
                }
            }
            DispatchQueue.main.async {
                self.setCacheDate()

                if let cachedArray = try? PropertyListEncoder().encode(self.scheduleData) {
                    self.UD.set(cachedArray, forKey: "ScheduleData")
                }
                self.data = self.scheduleData
                self.scheduleData = [Schedule]()
            }            
        })
        
        
    }
    func setCacheDate() {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        UD.set("\(month)-\(day)", forKey: "ScheduleCacheDate")
    }
    
    func loadEventsFromCache() {
        DispatchQueue.main.async {
            self.data = [Schedule]()
            self.scheduleData = [Schedule]()
            
            if let cachedData = self.UD.data(forKey: "ScheduleData") {
                self.data = try! PropertyListDecoder().decode([Schedule].self, from: cachedData)
            }
        }
       

    }
   func cacheDate() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        if let cachedData = UD.object(forKey: "ScheduleCacheDate") as? String {
            if cachedData == "\(month)-\(day)" {
                return true
            }
        }
        return false
    }
    
    private func dayFromDateString(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: dateString)
        
        let components = dateFormatter.weekdaySymbols?[Calendar.current.component(.weekday, from: date!)-1]
        
        return String(components?.prefix(3) ?? "Error")
    }
}

private func determineSeniority(userStatus: Profile) -> String {
    if (userStatus.user?.profile.email.contains("2024") == true ||
        userStatus.user?.profile.email.contains("2025") == true) {
        return "JR"
    }
    return "SR"
}

struct Schedule: Identifiable, Hashable, Codable {
    var id: String
    var summary: String
    var dotw: String
    var startDate: String
    var scheduleType: String
    var scheduleFamily: String
}
