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
                                ScheduleCard(schedule: schedule)
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
                                ScheduleCard(schedule: ScheduleArray.data[index])
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
//            .onAppear {
//                if (ScheduleArray.cacheDate() == false) {
//                    ScheduleArray.load()
//                }
//            }
            
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
                let index = self.data.firstIndex{$0.startDate == date}
                
                DispatchQueue.main.async {
                    if index != nil {
                        let id = self.data[index!].id
                        let dotw = self.data[index!].dotw
                        
                        self.data[index!] = Schedule(id: id, summary: blockRotation, dotw: dotw, startDate: date, scheduleType: scheduleType)
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
                var dotw: String

                if startDate != nil && summary.hasPrefix("Day 1") || summary.hasPrefix("Day 2") {
                    dotw = self.dayFromDateString(dateString: startDate!)
                    self.scheduleData.append(Schedule(id: id, summary: String(summary.suffix(4)), dotw: dotw, startDate: startDate!, scheduleType: "Regular Schedule"))
                }

            }
                        
            for item in items {
                let summary = item["summary"].stringValue
                var startDate = item["start"]["date"].string
                let startDateTime = item["start"]["dateTime"].string

                if startDate == nil && startDateTime != nil {
                    startDate = String(startDateTime!.prefix(10))
                }

                if summary.contains("Mass Schedule") || summary.hasPrefix("Academic/ Assembly") || summary.contains("Late Start")  {
                    var renameDict = [
                        "Academic/ Assembly Schedule": "Career Education Schedule",
                        "Staff & PLC Meeting Schedule": "Late Start Schedule"
                    ]
                    
                    if summary.contains("Mass Schedule") {
                        renameDict[summary] = "Mass Schedule"
                    }
                    
                    if summary.contains("Late Start") {
                        renameDict[summary] = "Late Start Schedule"
                    }

                    for (index, day) in self.scheduleData.enumerated() {
                        if day.startDate == String(startDate!) {
                            self.scheduleData[index].scheduleType = renameDict[summary] ?? "-"
                            break
                        }
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

struct Schedule: Identifiable, Hashable, Codable {
    var id: String
    var summary: String
    var dotw: String
    var startDate: String
    var scheduleType: String
}
