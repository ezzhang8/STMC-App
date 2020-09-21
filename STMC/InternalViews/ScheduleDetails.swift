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
    var seniority: String
    @ObservedObject fileprivate var CalendarEvents: CalendarEvents
    
    init(schedule: Schedule, seniority: String) {
        self.schedule = schedule
        self.seniority = seniority
        self.CalendarEvents = STMC.CalendarEvents(dateString: schedule.startDate)
    }
    
    var body: some View {
        List {
            Section (header:
                HStack {
                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("Block Rotation")
                        .font(.callout)
                        .textCase(.none)
                }
            ){
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Text(determineDay(blockSchedule: schedule.summary) + " - " + schedule.scheduleFamily)
                            .font(.headline)
                            .padding(.top)
                        Text(schedule.summary)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    }
                    Spacer()
                }
            }
            Section (header:
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(schedule.scheduleType)
                        .font(.callout)
                        .textCase(.none)
                }
            ){
                ForEach(generateSchedule(scheduleType: String("\(schedule.scheduleType) \(seniority)"), blocks: schedule.summary)!, id: \.self) { i in
                    HStack {
                        Text(i[0])
                            .fontWeight(.semibold)
                        Spacer()
                        Text(i[1])
                    }
                }
            }
            if !CalendarEvents.events.contains(nil) {
                Section (header:
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Events")
                            .font(.callout)
                            .textCase(.none)
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
    
    scheduleArray["Regular Schedule SR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:45"],
        ["Block \(blockArray[1])", "9:50-11:05"],
        ["Sr. School Break", "11:05-11:15"],
        ["Block \(blockArray[2])", "11:20-12:35"],
        ["Lunch", "12:35-1:10"],
        ["Block \(blockArray[3])", "1:15-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    scheduleArray["Regular Schedule JR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:45"],
        ["Jr. School Break", "9:45-9:55"],
        ["Block \(blockArray[1])", "10:00-11:15"],
        ["Lunch", "11;15-11:50"],
        ["Block \(blockArray[2])", "11:55-1:10"],
        ["Block \(blockArray[3])", "1:15-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    scheduleArray["CLE/CLC/Staff Meeting Schedule SR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Staff Meeting/PLC", "8:20-9:05"],
        ["Warning Bell", "9:10"],
        ["Block \(blockArray[0])", "9:15-10:00"],
        ["Block \(blockArray[1])", "10:05-10:50"],
        ["Block \(blockArray[2])", "10:55-11:40"],
        ["Sr. School Lunch", "11:40-12:10"],
        ["CE 10-12", "12:15-12:55"],
        ["Block \(blockArray[3])", "12:55-1:40"],
        ["COMPASS/FLEX Time", "1:45-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    scheduleArray["CLE/CLC/Staff Meeting Schedule JR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Staff Meeting/PLC", "8:20-9:05"],
        ["Warning Bell", "9:10"],
        ["Block \(blockArray[0])", "9:15-10:00"],
        ["Block \(blockArray[1])", "10:05-10:50"],
        ["Jr. School Lunch", "10:50-11:20"],
        ["Block \(blockArray[2])", "11:25-12:10"],
        ["CE 8/9", "12:15-12:55"],
        ["Block \(blockArray[3])", "12:55-1:40"],
        ["COMPASS/FLEX Time", "1:45-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    
    scheduleArray["Mass Schedule SR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:35"],
        ["Block \(blockArray[1])", "9:40-10:45"],
        ["Sr. School Break", "10:45-10:55"],
        ["Block \(blockArray[2])", "11:00-12:05"],
        ["Sr. School Lunch", "12:05-12:40"],
        ["Block \(blockArray[3]) & Mass", "12:45-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    
    scheduleArray["Mass Schedule JR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:35"],
        ["Jr. School Break", "9:35-9:45"],
        ["Block \(blockArray[1])", "9:50-10:55"],
        ["Jr. School Lunch", "10:55-11:30"],
        ["Block \(blockArray[2])", "11:35-12:40"],
        ["Block \(blockArray[3]) & Mass", "12:45-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    
    
    if scheduleArray[scheduleType] != nil {
        return scheduleArray[scheduleType] as? [[String]]
    }
    else {
        return nil
    }
}


