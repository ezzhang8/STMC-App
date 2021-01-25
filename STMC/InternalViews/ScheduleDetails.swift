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
    @ObservedObject fileprivate var Override: ScheduleOverride

    @State var seniorJunior: String
    
    init(schedule: Schedule, seniority: String) {
        self.schedule = schedule
        self.CalendarEvents = STMC.CalendarEvents(dateString: schedule.startDate)
        self.seniority = seniority
        self._seniorJunior = State(initialValue: seniority )
        self.Override = ScheduleOverride(schedule: schedule, seniority: seniority)

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
                            Image(systemName:"chevron.right.2")
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text(schedule.scheduleFamily)
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
                VStack (alignment: .leading){
                    HStack {
                        Picker(selection:$seniorJunior, label: Text("Picker")) {
                            Text("Senior Schedule")
                                .tag("SR")
                                .textCase(.none)
                            Text("Junior Schedule")
                                .tag("JR")
                                .textCase(.none)
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                }
            ){
                ForEach(generateSchedule(scheduleType: String("\(schedule.scheduleType) \(seniorJunior)"), blocks: schedule.summary) ?? Override.returnArray[seniorJunior]!, id: \.self) { i in
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
    
    scheduleArray["Regular Schedule SR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:45"],
        ["Block \(blockArray[1])", "9:50-11:05"],
        ["Sr. School Break", "11:05-11:15"],
        ["Block \(blockArray[2])", "11:20-12:35"],
        ["Sr. School Lunch", "12:35-1:10"],
        ["Block \(blockArray[3])", "1:15-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    scheduleArray["Regular Schedule JR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:45"],
        ["Jr. School Break", "9:45-9:55"],
        ["Block \(blockArray[1])", "10:00-11:15"],
        ["Jr. School Lunch", "11:15-11:50"],
        ["Block \(blockArray[2])", "11:55-1:10"],
        ["Block \(blockArray[3])", "1:15-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    scheduleArray["Career Education Schedule SR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:30"],
        ["Block \(blockArray[1])", "9:35-10:40"],
        ["Sr. School Break", "10:40-10:45"],
        ["Block \(blockArray[2])", "10:50-11:55"],
        ["Sr. School Lunch", "11:55-12:30"],
        ["CE 10-12", "12:35-1:25"],
        ["Block \(blockArray[3])", "1:25-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    scheduleArray["Career Education Schedule JR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["Warning Bell", "8:20"],
        ["Block \(blockArray[0])", "8:25-9:30"],
        ["Jr. School Break", "9:30-9:35"],
        ["Block \(blockArray[1])", "9:40-10:45"],
        ["Jr. School Lunch", "10:45-11:20"],
        ["Block \(blockArray[2])", "11:25-12:30"],
        ["CE 8-9", "12:35-1:25"],
        ["Block \(blockArray[3])", "1:25-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    
    scheduleArray["PLC/ Staff Meetings/ Compass Schedule SR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["PLC/Staff Meetings", "8:20-9:05"],
        ["Warning Bell", "9:10"],
        ["Block \(blockArray[0])", "9:15-10:10"],
        ["Block \(blockArray[1])", "10:15-11:10"],
        ["Block \(blockArray[2])", "11:15-12:10"],
        ["Sr. School Lunch", "12:10-12:45"],
        ["Block \(blockArray[3])", "12:50-1:45"],
        ["Compass Time", "1:50-2:30"],
        ["Afternoon Y Blocks", "2:35-3:50"]
    ]
    
    scheduleArray["PLC/ Staff Meetings/ Compass Schedule JR"] = [
        ["Morning X Blocks", "7:00-8:15"],
        ["PLC/Staff Meetings", "8:20-9:05"],
        ["Warning Bell", "9:10"],
        ["Block \(blockArray[0])", "9:15-10:10"],
        ["Block \(blockArray[1])", "10:15-11:10"],
        ["Jr. School Lunch", "11:10-11:45"],
        ["Block \(blockArray[2])", "11:50-12:45"],
        ["Block \(blockArray[3])", "12:50-1:45"],
        ["Compass Time", "1:50-2:30"],
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

private class ScheduleOverride: ObservableObject {
    @Published var returnArray = [
        "JR": [[String]](),
        "SR": [[String]](),
    ]
    
    init(schedule: Schedule, seniority: String) {
        self.schedule(schedule: schedule, seniority: seniority)
    }
    func schedule(schedule: Schedule, seniority: String) {
        sendRequest(url: String(API.url+"overrides/"), completion: { json in
            let error = json["error"].string

            if error != nil {
                self.loadScheduleFromCache(date: schedule.startDate)
                return
            }
            
            let array = json.array!
            
            for day in array {
                let date = day["date"].stringValue
                let scheduleJr = day["scheduleJr"].array!
                let scheduleSr = day["scheduleSr"].array!

                if date == schedule.startDate {
                    for row in scheduleJr {
                        let entry = [row["name"].stringValue, row["timeSlot"].stringValue]
                        DispatchQueue.main.async {
                            self.returnArray["JR"]!.append(entry)
                        }
                    }
                
                    for row in scheduleSr {
                        let entry = [row["name"].stringValue, row["timeSlot"].stringValue]
                        DispatchQueue.main.async {
                            self.returnArray["SR"]!.append(entry)
                            
                            if let cachedArray = try? PropertyListEncoder().encode(self.returnArray) {
                                UserDefaults.standard.set(cachedArray, forKey: "ScheduleFor"+date)
                            }
                        }
                    }
                }
            }
        })
    }
    func loadScheduleFromCache(date: String) {
        if let cachedData = UserDefaults.standard.data(forKey: "ScheduleFor"+date) {
            self.returnArray = try! PropertyListDecoder().decode([String: [[String]]].self, from: cachedData)
        }
    }
}
