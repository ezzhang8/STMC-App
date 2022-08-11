//
//  Widget.swift
//  Widget
//
//  Created by Eric Zhang on 2020-08-21.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import WidgetKit
import SwiftUI
import SwiftyJSON

class Model: TimelineEntry, ObservableObject {
    var date: Date
    @Published var widgetData: [Schedule]
    
    init(date: Date, widgetData: [Schedule]) {
        self.date = date
        self.widgetData = widgetData
    }
    
    func changeSchedule(schedule: Schedule) {
        DispatchQueue.main.async {
            self.widgetData[0] = schedule
        }
    }
}

struct WidgetView: View {
    @ObservedObject var data: Model

    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                )
            Image("STMC")
                .resizable()
                .frame(width: 110, height: 128)
                .shadow(radius: 8)
                .opacity(0.3)
                .offset(x: 50, y: 40)
            VStack(alignment: .leading){
                VStack(alignment: .center){
                    Text(data.widgetData[0].dotw)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.white)
                }
                    
                
                Text(formatDate(dateString: data.widgetData[0].startDate))
                    .font(.system(.subheadline, design: .rounded))

                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(data.widgetData[0].summary)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                Text(String("\(data.widgetData[0].scheduleType)"))
                    .font(.footnote)
                    .foregroundColor(.white)
                    .lineLimit(3)
                    
            }
            .padding(.horizontal, 10)
            .frame(width: 300)
        }
    }
}

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping(Model)-> Void) {
        let loadingData = Model(date: Date(), widgetData: [Schedule(date: Date(), id: "1", summary: "ABCD", dotw: "Monday", startDate: "2020-03-22", scheduleType: "Regular Schedule")])
        completion(loadingData)
    }
    func placeholder(in context: Context) -> Model {
            
            // inital snapshot....
            // or loading type content....
            
        let loadingData = Model(date: Date(), widgetData: [Schedule(date: Date(), id: "1", summary: "ABCD", dotw: "Monday", startDate: "2020-03-22", scheduleType: "Regular Schedule")])
            
            return loadingData
    }
    func getTimeline(in context: Context, completion: @escaping(Timeline<Model>) -> Void) {
        sendRequest(url: API.calendar, completion: { json in
            let error = json["error"].string
            var scheduleData = [Schedule]()

            if error != nil {
                DispatchQueue.main.async {
                    if let cachedData = UserDefaults.standard.data(forKey: "WidgetData") {
                        scheduleData = try! PropertyListDecoder().decode([Schedule].self, from: cachedData)
                    }
                }
                return
            }
            
            let date = Date()
            
            let items = json["items"].array!
            
            for item in items {
                let summary = item["summary"].stringValue
                let id = item["id"].stringValue
                let startDate = item["start"]["date"].string
                var dotw: String

                if startDate != nil && summary.hasPrefix("Day 1") || summary.hasPrefix("Day 2") {
                    dotw = dayFromDateString(dateString: startDate!)
                    scheduleData.append(Schedule(date: date, id: id, summary: String(summary.suffix(4)), dotw: dotw, startDate: startDate!, scheduleType: "Regular Schedule"))
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
                        "Academic/ Assembly Schedule": "Academic/Assembly Schedule",
                        "Staff & PLC Meeting Schedule": "Late Start Schedule"
                    ]
                    
                    if summary.contains("Mass Schedule") {
                        renameDict[summary] = "Mass Schedule"
                    }
                    
                    if summary.contains("Late Start") {
                        renameDict[summary] = "Late Start Schedule"
                    }

                    for (index, day) in scheduleData.enumerated() {
                        if day.startDate == String(startDate!) {
                            scheduleData[index].scheduleType = renameDict[summary] ?? "-"
                            break
                        }
                    }
                }
                
            }
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: date)
            let data = Model(date: date, widgetData: scheduleData)

            let timeline = Timeline(entries: [data] , policy: .after(nextUpdate!))
            completion(timeline)

        })
    }
}

@main
struct MainWidget : Widget {
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Widget", provider: Provider()) { data in
            WidgetView(data: data)
        }
        .description(Text("Shows an overview of the next school day."))
        .configurationDisplayName(Text("STMC Widget"))
        .supportedFamilies([.systemSmall])
    }
}

private func dayFromDateString(dateString: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en-US")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date = dateFormatter.date(from: dateString)
    
    let components = dateFormatter.weekdaySymbols?[Calendar.current.component(.weekday, from: date!)-1]
    
    return String(components ?? "Error")
}

private func formatDate (dateString: String) -> String {
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

struct Schedule: Identifiable, Hashable, TimelineEntry, Codable {
    var date: Date
    var id: String
    var summary: String
    var dotw: String
    var startDate: String
    var scheduleType: String
}

func syncRequest(_ url: String) -> (JSON, Error?) {
    var data: Data?
    var error: Error?
    let url = URL(string: url)!
    let semaphore = DispatchSemaphore(value: 0)
    let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) {
        data = $0
        error = $2
        semaphore.signal()
    }
    dataTask.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    
    let json = try! JSON(data: data ?? Data(), options: .allowFragments)
    return (json, error)
}
