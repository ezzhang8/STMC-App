//
//  NotificationTab.swift
//  STMC
//
//  Created by Eric Zhang on 2020-11-28.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import MobileCoreServices

struct NotificationTab: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var notlog: NotificationLog
    @ObservedObject var notifications = NotificationHandler()
    @State private var isShowing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(notifications.data, id: \.self) { notification in
                    NotificationEntry(notification: notification)
                        .environmentObject(notlog)
                }
                
            }
            .background(Color.GR.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarTitle(Text("Notifications"))
            .accentColor(.LC)
            .onAppear {
                notlog.addArray(array: notifications.data)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            notifications.load()
        }
    }
}

struct Notification: Hashable, Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var date: String
    var time: String
    var link: URL?
}

struct NotificationEntry: View {
    var notification: Notification
    @EnvironmentObject var notlog: NotificationLog

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(notification.date)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.leading, 10)
                    Spacer()
                    Text(notification.time)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.trailing, 10)
                }
                .padding([.top, .leading, .trailing], 12)

                ZStack {
                    Image("STMC")
                        .resizable()
                        .frame(width: 110, height: 128)
                        .shadow(radius: 8)
                        .opacity(0.3)
                        .offset(x: 100, y: 40)
                    VStack(alignment: .leading) {
                        HStack {
                            if !notlog.read.contains(notification.id) || notlog.justAdded.contains(notification.id) {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(Color.blue)
                            }
                            Text(notification.name)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white)
                        }
                        Divider()
                            .background(Color.white)
                        Text(notification.description)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))

                            .foregroundColor(Color.white)
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: { UIPasteboard.general.setValue(notification.description as Any,forPasteboardType: kUTTypePlainText as String)}, label: {
                                    Text("Copy to Clipboard")
                                    Image(systemName: "doc.on.doc")
                                })
                            }))
                    }
                    .padding(15)
                }
                .background(
                    LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))

                .padding(.bottom, 5)
                .padding(.horizontal, 15)
            }

        }
    }
}

class NotificationHandler: ObservableObject {
    @Published var data = [Notification]()
    
    init() {
        self.load()
    }
    
    func load() {
        sendRequest(url: API.url+"notifications/", completion: { json in
            let error = json["error"].string

            if error != nil {
                DispatchQueue.main.async {
                    if let cachedData = UserDefaults.standard.data(forKey: "Notifications") {
                        self.data = try! PropertyListDecoder().decode([Notification].self, from: cachedData)
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self.data = [Notification]()
            }
            
            let notifications = json["notifications"].array!
                        
            for notification in notifications {
                let id = notification["id"].stringValue
                let time = self.formatTime(time: notification["delivery_time_of_day"].stringValue)
                let title = notification["headings"]["en"].stringValue
                let description = notification["contents"]["en"].stringValue
                let date = self.dateToDateString(unix: notification["queued_at"].intValue)
                
                DispatchQueue.main.async {
                    self.data.append(Notification(id: id, name: title, description: description, date: date, time: time))
                }
                
            }
            
            if let cachedArray = try? PropertyListEncoder().encode(self.data) {
                UserDefaults.standard.set(cachedArray, forKey: "Notifications")
            }
        })
    }
    
    func formatTime(time: String) -> String {
        let ampm = time.suffix(2)
        let realTime = time.dropLast(2)
        
        return realTime + " " + ampm
    }
    
    func dateToDateString(unix: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        let dateFormatter = DateFormatter()
    
        dateFormatter.timeZone = TimeZone.init(abbreviation: "en")
        dateFormatter.locale = Locale.init(identifier: "en")
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let outputDate = dateFormatter.string(from: date)
            
        
        return outputDate
    }
}
