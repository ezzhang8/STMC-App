//
//  CalendarView.swift
//  STMC
//
//  Created by Eric Zhang on 2019-12-01.
//  Copyright © 2019 Eric Zhang. All rights reserved.

import SwiftUI
import SwiftyJSON

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var view = "Calendar"
    var body: some View {
        NavigationView {
            CalendarList()
            .navigationBarTitle(Text("Calendar"))
            .navigationBarItems(leading:
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .accentColor(.STMC)
                        .scaledToFit()
                }
                .frame(width: 20, height: 20)
            )
        }
        .accentColor(.STMC)
        .font(.body)
    }
}
struct CalendarList: View {
    @ObservedObject private var Calendar = CalendarEvents()

    var body: some View {
        if self.Calendar.events.count == 0 {
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 50, height: 50)
                Spacer()

            }
        }
        List {
            ForEach (Array(Calendar.months.enumerated()), id: \.element) { index, month in
                if self.Calendar.events[index].count > 0 {
                    Section (header:
                        Text(month)
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    ) {
                        if self.Calendar.events.count > 0 {
                            ForEach(self.Calendar.events[index], id: \.self) { event in
                                NavigationLink(destination: CalendarDetails(CalendarEvent: event)) {
                                    HStack {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.white)
                                                .frame(width: 22, height: 22)
                                                .cornerRadius(11)
                                            Image(systemName: "\(formatDay(dayString: event.startDate)).circle.fill")
                                                .resizable()
                                                .foregroundColor(.STMC)
                                                .frame(width: 22, height: 22)
                                                .scaledToFit()

                                        }
                                        Text(event.summary)
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct CalendarEvent: Identifiable, Hashable, Codable {
    var id: String
    var summary: String
    var startDate: String
    var endDate: String
    var startTime: String?
    var endTime: String?
    var description: String?
    var htmlLink: String
}

private class CalendarEvents: ObservableObject {
    @Published var events = [[CalendarEvent]]()
    
    // The months that the calendar events span
    @Published var months = [String]()
    
    init() {
        if self.cacheDate() {
            self.loadEventsFromCache()
            return
        }
        sendRequest(url: API.calendar, completion: {json in
            let error = json["error"].string
            
            if error != nil  {
                self.loadEventsFromCache()
                return
            }
            let items = json["items"].array!
            var monthsContainer = [String]()
            var eventsContainer = [[CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent]()]
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
                let month = self.formatMonth(dateString: startDate)

                if monthsContainer.last != month && startDate != nil{
                    monthsContainer.append(month!)
                    
                }
                if !summary.hasPrefix("MORE - ") && !summary.hasPrefix("RICE - ") 	{
                    eventsContainer[monthsContainer.count-1].append(CalendarEvent(id: id, summary: summary, startDate: startDate!, endDate: endDate!, startTime: startDateTime, endTime: endDateTime, description: description, htmlLink: htmlLink))
                }
                
            
            }
            
            DispatchQueue.main.async {
                self.months = monthsContainer
                self.events = eventsContainer
            }
            
            if let cachedArray = try? PropertyListEncoder().encode(eventsContainer) {
                UserDefaults.standard.set(cachedArray, forKey: "CalendarEvents")
            }
            if let cachedMonths = try? PropertyListEncoder().encode(monthsContainer) {
                UserDefaults.standard.set(cachedMonths, forKey: "CalendarMonths")
            }
            
            self.setCacheDate()
            
        })
    }
    private func setCacheDate() {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        UserDefaults.standard.set("\(month)-\(day)", forKey: "CalendarCacheDate")

        
    }
    
    private func loadEventsFromCache() {
        DispatchQueue.main.async {
            if let cachedData = UserDefaults.standard.data(forKey: "CalendarEvents") {
                self.events = try! PropertyListDecoder().decode([[CalendarEvent]].self, from: cachedData)
            }
            if let cachedMonths = UserDefaults.standard.data(forKey: "CalendarMonths") {
                self.months = try! PropertyListDecoder().decode([String].self, from: cachedMonths)
            }
        }
    }
    private func cacheDate() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        if let cachedData = UserDefaults.standard.object(forKey: "CalendarCacheDate") as? String {
            if cachedData == "\(month)-\(day)" {
                return true
            }
        }
        return false
    }
    
    
    // Takes a date string in the format yyyy-mm-dd and returns the month associated with the date string as a word.
    private func formatMonth(dateString: String?) -> String? {
        if dateString != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en-US")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: dateString!)
            
            let month = String((dateFormatter.monthSymbols?[Calendar.current.component(.month, from: date!)-1]) ?? "Error")
            
            return month
        }
        return nil
    }
}



struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

