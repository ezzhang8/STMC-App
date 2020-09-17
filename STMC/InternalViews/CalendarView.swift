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
        List {
            ForEach (Array(Calendar.months.enumerated()), id: \.element) { index, month in
                Section (header:
                    HStack {
                        Text(month)
                            .font(.callout)
                            .fontWeight(.bold)
                            .textCase(.none)
                }){
                    ForEach(self.Calendar.events[index], id: \.self) { event in
                        NavigationLink(destination: CalendarDetails(CalendarEvent: event)) {
                            HStack {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .frame(width:20, height:20)
                                        .cornerRadius(10)
                                    Image(systemName: "\(formatDay(dayString: event.startDate)).circle.fill")
                                        .resizable()
                                        .foregroundColor(.STMC)
                                        .frame(width:20, height:20)
                                        .scaledToFit()

                                }
                                Text(event.summary)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct CalendarEvent: Identifiable, Hashable {
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
    @Published var events = [[CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent](), [CalendarEvent]()]
    
    // The months that the calendar events span
    @Published var months = [String]()
    
    init() {
        sendRequest(url: API.calendar, completion: {json in
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
                let month = self.formatMonth(dateString: startDate)

                if self.months.last != month && startDate != nil{
                    DispatchQueue.main.sync {
                        self.months.append(month!)
                    }
                }
                if !summary.hasPrefix("MORE - ") && !summary.hasPrefix("RICE - ") 	{
                    DispatchQueue.main.sync {
                        if self.events.indices.contains(self.months.count-1) {
                            self.events[self.months.count-1].append(CalendarEvent(id: id, summary: summary, startDate: startDate!, endDate: endDate!, startTime: startDateTime, endTime: endDateTime, description: description, htmlLink: htmlLink))
                        }
                    }
                }
                
                print(self.events);
                print(self.months);
            }
        })
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

