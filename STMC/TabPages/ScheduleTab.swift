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
    @State var showingCalendar = false
    @ObservedObject fileprivate var ScheduleArray = Schedules()
    
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
                        ScheduleCard(schedule: ScheduleArray.today)
                        .padding(.bottom)
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
                            
                    }
                    .padding(.leading)
                ){
                    VStack {
                        ForEach(Array(ScheduleArray.data.enumerated()), id: \.element) { index, schedule in
                            if index > 0 {
                                ScheduleCard(schedule: schedule)
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
    @Published var today = Schedule(id: "", summary: "", dotw: "", startDate: "", scheduleType: "")
    
    var scheduleData = [Schedule]()
    init() {
        sendRequest(url: API.calendar, completion: { json in
            let items = json["items"].array!
            
            for item in items {
                let summary = item["summary"].stringValue
                let id = item["id"].stringValue
                let startDate = item["start"]["date"].string
                var dotw: String
                
                if startDate != nil && summary.hasPrefix("Day 1") || summary.hasPrefix("Day 2") {
                    dotw = dayFromDateString(dateString: startDate!)
                    
                
                    self.scheduleData.append(Schedule(id: id, summary: String(summary.suffix(4)), dotw: dotw, startDate: startDate!, scheduleType: "Regular Schedule"))
                    
                }
            }
            for item in items {
                var summary = item["summary"].stringValue
                var startDate = item["start"]["date"].string
                let startDateTime = item["start"]["dateTime"].string
                
                if startDate == nil && startDateTime != nil {
                    startDate = String(startDateTime!.prefix(10))
                }
                
                if summary.hasPrefix("Mass Schedule") || summary.hasPrefix("Academic Assembly") || summary.hasPrefix("Staff/PLC")  {
                    
                    if summary.hasPrefix("Staff/PLC") {
                        summary = "Late Start"
                    }
                    
                    for (index, day) in self.scheduleData.enumerated() {
                        if day.startDate == String(startDate!) {
                            self.scheduleData[index].scheduleType = summary
                            break
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.today = self.scheduleData[0]
                self.data = self.scheduleData
            }
        })
    }
}

private func dayFromDateString(dateString: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en-US")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date = dateFormatter.date(from: dateString)
    
    let components = dateFormatter.weekdaySymbols?[Calendar.current.component(.weekday, from: date!)-1]
    
    return String(components?.prefix(3) ?? "Error")
}

struct Schedule: Identifiable, Hashable {
    var id: String
    var summary: String
    var dotw: String
    var startDate: String
    var scheduleType: String
}

struct ScheduleTab_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleTab()
    }
}
