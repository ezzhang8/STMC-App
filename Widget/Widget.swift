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
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                Text(data.widgetData[0].scheduleFamily)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(String("\(data.widgetData[0].scheduleType)"))
                    .font(.footnote)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .frame(width: 300)
        }
    }
}

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping(Model)-> Void) {
        let loadingData = Model(date: Date(), widgetData: [Schedule(date: Date(), id: "1", summary: "ABCD", dotw: "Monday", startDate: "2020-03-22", scheduleType: "Regular Schedule", scheduleFamily: "RICE")])
        completion(loadingData)
    }
    func placeholder(in context: Context) -> Model {
            
            // inital snapshot....
            // or loading type content....
            
        let loadingData = Model(date: Date(), widgetData: [Schedule(date: Date(), id: "1", summary: "ABCD", dotw: "Monday", startDate: "2020-03-22", scheduleType: "Regular Schedule", scheduleFamily: "RICE")])
            
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
                
                
                if startDate != nil && summary.hasPrefix("MORE - ") || summary.hasPrefix("RICE - ") {
                    var dotw: String
                    
                    let scheduleComponents = summary.components(separatedBy: " - ")
                    dotw = dayFromDateString(dateString: startDate!)
                    
                    if scheduleComponents.count > 2 {
                        scheduleData.append(Schedule(date: date, id: id, summary: scheduleComponents[1], dotw: dotw, startDate: startDate!, scheduleType: scheduleComponents[2], scheduleFamily: scheduleComponents[0]))
                    }
                    else {
                        scheduleData.append(Schedule(date: date, id: id, summary: scheduleComponents[1], dotw: dotw, startDate: startDate!, scheduleType: "Regular Schedule", scheduleFamily: scheduleComponents[0]))
                    }
                }
            }
            
            DispatchQueue.global().async {
                let request = syncRequest(API.url+"overrides/")
                let json = request.0
                let error = request.1
                
                if error != nil {
                    return
                }
                
                let array = json.array!

                for day in array {
                    let dateStart = day["date"].stringValue
                    let blockRotation = day["blockRotation"].stringValue
                    let scheduleType = day["scheduleType"].stringValue
                    let scheduleFamily = day["scheduleFamily"].stringValue

                    if scheduleData[0].startDate == dateStart {
                        scheduleData[0] = Schedule(date: date, id: "override", summary: blockRotation, dotw: scheduleData[0].dotw, startDate: dateStart, scheduleType: scheduleType, scheduleFamily: scheduleFamily)
                    }
                }
                
                if let cachedArray = try? PropertyListEncoder().encode(scheduleData) {
                    UserDefaults.standard.set(cachedArray, forKey: "WidgetData")
                }
                
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: date)
                let data = Model(date: date, widgetData: scheduleData)

                let timeline = Timeline(entries: [data] , policy: .after(nextUpdate!))
                completion(timeline)
            }
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
    var scheduleFamily: String
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
