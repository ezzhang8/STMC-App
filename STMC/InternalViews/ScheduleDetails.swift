//
//  SwiftUIView.swift
//  STMC
//
//  Created by Eric Zhang on 2019-11-24.
//  Copyright © 2019 Eric Zhang. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct ScheduleDetails: View {
    var schedule: Schedule
    @ObservedObject fileprivate var CalendarEvents: CalendarEvents
    @ObservedObject fileprivate var Override: ScheduleOverride

    let scheduleStyling = [
        "Morning X Blocks", Font.bold
    ] as [Any]
    
    init(schedule: Schedule) {
        self.schedule = schedule
        self.CalendarEvents = STMC.CalendarEvents(dateString: schedule.startDate)
        self.Override = ScheduleOverride(schedule: schedule)

    }
    
    var body: some View {
        List {
            Section (header:
                HStack {
                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.primary)
                    Text("Block Rotation")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .textCase(.none)
                        .foregroundColor(Color.primary)
                }
            ){
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        HStack {
                            Text(determineDay(blockSchedule: schedule.summary))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .padding(.vertical, 2)
                                .padding(.horizontal, 5)
                        }
                        .padding(.top, 5)
                        Text(schedule.summary)
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .padding(.vertical, 1)
                            .foregroundColor(colorMatch(scheduleType: schedule.scheduleType))
                        
                        Text(schedule.scheduleType)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 5)

                        
                    }
                    Spacer()
                }
            }
            Section (header:
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.primary)
                    Text("Schedule")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .textCase(.none)
                        .foregroundColor(Color.primary)
                }
            ){
                ForEach((generateSchedule(scheduleType: schedule.scheduleType, blocks: schedule.summary) ?? Override.returnArray)!, id: \.self) { i in
                    VStack {
                        HStack {
                            Text(i[0])
                                .fontWeight(.semibold)
                            Spacer()
                            Text(i[1])
                        }
                    }
                }
            }
            if !CalendarEvents.events.contains(nil) {
                Section (header:
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.primary)
                        Text("Events")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }
                ){
                    ForEach(CalendarEvents.events, id: \.self) { event in
                        NavigationLink(destination: CalendarDetails(CalendarEvent: event!)) {
                            Text(event!.summary)
                        }
                    }
                }
            }
            
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text(formatDate(dateString: schedule.startDate)))
    }
}

func formatDate (dateString: String) -> String {
    if dateString.count > 1 {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: dateString)
        let month = String((dateFormatter.monthSymbols?[Calendar.current.component(.month, from: date!)-1])!)
        var day = String(dateString.suffix(2))
        
        if day.hasPrefix("0") {
            day = String(dateString.suffix(1))
        }
    
        return String("\(month) \(day)")
    }
    else {
        return " "
    }
}

private class CalendarEvents: ObservableObject {
    @Published var events = [CalendarEvent?]()
    var dateString: String
    
    init(dateString: String) {
        self.dateString = dateString
        
        sendRequest(url: API.calendar, completion: { json in
            let error = json["error"].string

            if error != nil {
                DispatchQueue.main.async {
                    if let cachedData = UserDefaults.standard.data(forKey: "ScheduleDetailsCalendarFor"+dateString) {
                        self.events = try! PropertyListDecoder().decode([CalendarEvent].self, from: cachedData)
                    }
                }
                return
            }
            let items = json["items"].array!
            
            for item in items {
                // General event information
                let id = item["id"].stringValue
                let summary = item["summary"].stringValue
                let description = item["description"].string
                let htmlLink = item["htmlLink"].stringValue

                // Event time information
                var startDate = item["start"]["date"].string
                var endDate = item["start"]["date"].string
                let startDateTime = item["start"]["dateTime"].string
                let endDateTime = item["end"]["dateTime"].string

                if startDate == nil && startDateTime != nil {
                    startDate = String(startDateTime!.prefix(10))
                    endDate = String(endDateTime!.prefix(10))
                }
                if startDate == self.dateString {
                    DispatchQueue.main.sync {
                        self.events.append(CalendarEvent(id: id, summary: summary, startDate: startDate!, endDate: endDate!, startTime: startDateTime, endTime: endDateTime, description: description, htmlLink: htmlLink))
                    }
                }
            }
            if self.events.count < 1 {
                DispatchQueue.main.async {
                    self.events.append(nil)
                }
            }
            if let cachedArray = try? PropertyListEncoder().encode(self.events) {
                UserDefaults.standard.set(cachedArray, forKey: "ScheduleDetailsCalendarFor"+dateString)
            }
        })
    }
}

private func determineDay(blockSchedule: String) -> String {
    if blockSchedule.contains("A") {
        return "Day 1"
    }
    else {
        return "Day 2"
    }
}

private func generateSchedule(scheduleType: String, blocks: String) -> [[String]]? {
    let blockArray = Array(blocks)
    var scheduleArray = Dictionary<String, Any>()
    
    scheduleArray["Regular Schedule"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:45"],
        ["Block \(blockArray[1])", "9:50-11:05"],
        ["Break", "11:05-11:15"],
        ["Block \(blockArray[2])", "11:20-12:35"],
        ["Lunch", "12:35-1:20"],
        ["Block \(blockArray[3])", "1:25-2:40"],
        ["Afternoon Y Blocks", "2:45-4:00"]
    ]
    scheduleArray["Late Start Schedule"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Staff Meeting/PLC", "8:20-9:05"],
        ["Warning Bell", "9:10"],
        ["Block \(blockArray[0])", "9:20-10:25"],
        ["Block \(blockArray[1])", "10:35-11:35"],
        ["Block \(blockArray[2])", "11:40-12:45"],
        ["Lunch", "12:45-1:30"],
        ["Block \(blockArray[3])", "1:35-2:40"],
        ["Afternoon Y Blocks", "2:45-4:00"]
    ]
    scheduleArray["Career Education Schedule"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:30"],
        ["Block \(blockArray[1])", "9:35-10:40"],
        ["Break", "10:40-10:50"],
        ["Block \(blockArray[2])", "10:55-12:00"],
        ["Lunch", "12:00-12:40"],
        ["Career Ed", "12:45-1:35"],
        ["Block \(blockArray[3])", "1:35-2:40"],
        ["Afternoon Y Blocks", "2:45-4:00"]
    ]
    scheduleArray["Mass Schedule"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:35"],
        ["Block \(blockArray[1])", "9:40-10:45"],
        ["Break", "10:45-10:55"],
        ["Block \(blockArray[2]) & Mass", "11:00-12:50"],
        ["Lunch", "12:50-1:30"],
        ["Block \(blockArray[3])", "1:35-2:40"],
        ["Afternoon Y Blocks", "2:45-4:00"]
    ]
    
    if scheduleArray[scheduleType] != nil {
        return scheduleArray[scheduleType] as? [[String]]
    }
    else {
        return nil
    }
}

private class ScheduleOverride: ObservableObject {
    @Published var returnArray = [[String]]()
    
    
    init(schedule: Schedule) {
        self.schedule(schedule: schedule)
    }
    func schedule(schedule: Schedule) {
        sendRequest(url: String(API.url+"overrides/"), completion: { json in
            let error = json["error"].string

            if error != nil {
                self.loadScheduleFromCache(date: schedule.startDate)
                return
            }
            
            let array = json.array!
            
            for day in array {
                let date = day["date"].stringValue
                let scheduleJson = day["schedule"].array!

                if date == schedule.startDate {
                    for row in scheduleJson {
                        let entry = [row["name"].stringValue, row["timeSlot"].stringValue]
                        DispatchQueue.main.async {
                            self.returnArray.append(entry)
                        }
                    }
                }
            }
        })
    }
    func loadScheduleFromCache(date: String) {
        if let cachedData = UserDefaults.standard.data(forKey: "ScheduleFor"+date) {
            self.returnArray = try! PropertyListDecoder().decode([[String]].self, from: cachedData)
        }
    }
}
