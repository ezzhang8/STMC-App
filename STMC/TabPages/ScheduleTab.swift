//
//  ScheduleTab.swift
//  STMC
//
//  Created by Eric Zhang on 2019-11-24.
//  Copyright © 2019 Eric Zhang. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct ScheduleTab: View {
    @EnvironmentObject var userStatus: Profile
    @State var showingCalendar = false
    @ObservedObject private var ScheduleArray = Schedules()
    
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
                            Text("Next")
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
                        ForEach(Array(ScheduleArray.data.enumerated()), id: \.element) { index, schedule in
                            if index > 0 {
                                ScheduleCard(schedule: schedule, seniority: determineSeniority(userStatus: userStatus))
                            }
                            
                        }
                        Spacer()
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
        }
    }
}

private class Schedules: ObservableObject {
    @Published var data = [Schedule]()

    var scheduleData = [Schedule]()
    init() {
        sendRequest(url: API.calendar, completion: { json in
            let error = json["error"].string

            if error == "The Internet connection appears to be offline." {
                DispatchQueue.main.async {
                    if let cachedData = UserDefaults.standard.data(forKey: "ScheduleData") {
                        self.data = try! PropertyListDecoder().decode([Schedule].self, from: cachedData)
                    }
                }
                return
            }
            else if error != nil {
                return
            }
            let items = json["items"].array!
            
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
                if let cachedArray = try? PropertyListEncoder().encode(self.scheduleData) {
                    UserDefaults.standard.set(cachedArray, forKey: "ScheduleData")
                }
                self.data = self.scheduleData
            }
            
        })
        
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
    if (userStatus.user?.profile.email.contains("2021") == true ||
        userStatus.user?.profile.email.contains("2022") == true ||
        userStatus.user?.profile.email.contains("2023") == true) {
        return "SR"
    }
    return "JR"
}

struct Schedule: Identifiable, Hashable, Codable {
    var id: String
    var summary: String
    var dotw: String
    var startDate: String
    var scheduleType: String
    var scheduleFamily: String
}

struct ScheduleTab_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleTab()
    }
}
