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
    
    init(schedule: Schedule) {
        self.schedule = schedule
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
                        Text(determineDay(blockSchedule: schedule.summary))
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
                ForEach(generateSchedule(scheduleType: schedule.scheduleType, blocks: schedule.summary)!, id: \.self) { i in
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
                    HStack {
                        ForEach(CalendarEvents.events, id: \.self) { event in
                            NavigationLink(destination: CalendarDetails(CalendarEvent: event!)) {
                                Text(event!.summary)
                            }
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
                
                if startDate == self.dateString && !summary.hasPrefix("Day 1") &&  !summary.hasPrefix("Day 2") && !summary.hasPrefix("Staff") && !summary.hasPrefix("Mass") && !summary.hasPrefix("Academic Assembly") {
                    DispatchQueue.main.async {
                        self.events.append(CalendarEvent(id: id, summary: summary, startDate: startDate!, endDate: endDate!, startTime: startDateTime, endTime: endDateTime, description: description, htmlLink: htmlLink))
                    }
                }
            }
            
            if self.events.count < 1 {
                DispatchQueue.main.async {
                    self.events.append(nil)
                }
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
        ["Morning X Block", "7:00-8:15"],
        ["Block \(blockArray[0])", "8:25-9:40"],
        ["Block \(blockArray[1])", "9:45-11:00"],
        ["Break", "11:00-11:15"],
        ["Block \(blockArray[2])", "11:20-12:35"],
        ["Lunch", "12:35-1:20"],
        ["Block \(blockArray[3])", "1:25-2:40"],
        ["Afternoon Y Block", "2:45-4:00"]
    ]
    scheduleArray["Late Start"] = [
        ["Morning X Block", "7:00-8:15"],
        ["Staff Meeting/PLC", "8:15-9:10"],
        ["Block \(blockArray[0])", "9:20-10:25"],
        ["Block \(blockArray[1])", "10:30-11:35"],
        ["Lunch", "11:35-12:20"],
        ["Block \(blockArray[2])", "12:25-1:30"],
        ["Block \(blockArray[3])", "1:35-2:40"],
        ["Afternoon Y Block", "2:45-4:00"]
    ]
    scheduleArray["Academic Assembly Schedule"] = [
        ["Morning X Block", "7:00-8:15"],
        ["Block \(blockArray[0])", "8:25-9:25"],
        ["Block \(blockArray[1])", "9:30-10:30"],
        ["Break", "10:30-10:45"],
        ["Block \(blockArray[2])", "10:50-11:50"],
        ["Lunch", "11:50-12:40"],
        ["A/A Block", "12:45-1:35"],
        ["Block \(blockArray[3])", "1:40-2:40"],
        ["Afternoon Y Block", "2:45-4:00"]
    ]
    scheduleArray["Mass Schedule"] = [
        ["Morning X Block", "7:00-8:15"],
        ["Block \(blockArray[0])", "8:25-9:25"],
        ["Break", "9:25-9:35"],
        ["Block \(blockArray[1])", "9:40-10:40"],
        ["Mass", "10:45-11:45"],
        ["Lunch", "11:45-12:30"],
        ["Block \(blockArray[2])", "12:35-1:35"],
        ["Block \(blockArray[3])", "1:40-2:40"],
        ["Afternoon Y Block", "2:45-4:00"]
    ]
    
    if scheduleArray[scheduleType] != nil {
        return scheduleArray[scheduleType] as? [[String]]
    }
    else {
        return nil
    }
}

struct ScheduleDetails_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDetails(schedule: Schedule(id: "", summary: "", dotw: "", startDate: "", scheduleType: ""))
    }
}
