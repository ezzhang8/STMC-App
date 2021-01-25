//
//  MainView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-19.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import UIKit
import Network
import StatefulTabView

struct MainView: View {
    @EnvironmentObject var userStatus: Profile
    @ObservedObject fileprivate var network = NetworkConnection()
    @ObservedObject var notlog = NotificationLog()

    @State var badgeValue: String = String()
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.TBRC)
    }
    
    var alert: Alert {
        Alert(title: Text("No connection"), message: Text("STMC requires access to Wi-Fi or cellular data to update information. Some information may be outdated or inaccessible without a network connection."), dismissButton: .default(Text("OK")))
    }

    var body: some View {
        StatefulTabView {
            Tab(title: "Schedule", systemImageName: "clock.fill") {
                ScheduleTab()
                    .environmentObject(userStatus)

            }
            Tab(title: "Explore", systemImageName: "rectangle.3.offgrid.fill") {
                ExploreTab()
                    .environmentObject(userStatus)

            }

            Tab(title: "Notifications", systemImageName: "bell.fill", badgeValue: notlog.badgeValue) {
                NotificationTab()
                    .environmentObject(notlog)
            }
            .prefersLargeTitle(true)

            Tab(title: "Resources", systemImageName: "bookmark.fill") {
                ResourcesTab()
            }
            .prefersLargeTitle(true)

        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(.STMC)
        .alert(isPresented: $network.connected, content: {self.alert})
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            print("Refreshing schedule")
            notlog.countNotifications()
        }
    }
}

class NotificationLog: ObservableObject {
    @Published var read = [String]()
    @Published var count = 0
    @Published var badgeValue: String?
    
    var readContainer = [String]()
    var justAdded = [String]()
    var notifications = [Notification]()
    let UD = UserDefaults.standard
    
    init() {
        self.load()
        self.countNotifications()
    }
    
    func addArray(array: [Notification]) {
        self.notifications = array
                         
        for notification in self.notifications {
            if (!self.readContainer.contains(notification.id)) {
                self.readContainer.append(notification.id)
                self.justAdded.append(notification.id)
            }
        }
        self.UD.set(self.readContainer, forKey: "NotificationsLog")
        
        DispatchQueue.main.async {
            self.read = self.readContainer

//            if self.count - self.read.count < 1 {
//                self.badgeValue = nil
//            }
//            else {
//                self.badgeValue = String(self.count - self.read.count)
//            }
            
            self.badgeValue = nil
        }
    }
    
    func clearAll() {
        self.readContainer = [String]()
        DispatchQueue.main.async {
            self.read = [String]()
        }
        self.UD.set([String](), forKey: "NotificationsLog")
        self.UD.synchronize()
    }
    
    func countNotifications() {
        sendRequest(url: API.url+"notifications/", completion: { json in
            let error = json["error"].string

            if error != nil {
                return
            }

            let notifications = json["notifications"].array!
            
            DispatchQueue.main.async {
                self.count = notifications.count
                
                if self.count - self.read.count < 1 {
                    self.badgeValue = nil
                }
                else {
                    self.badgeValue = String(self.count - self.read.count)
                }
            }
        })
    }
    
    func load() {
        self.readContainer = self.UD.array(forKey: "NotificationsLog") as? [String] ?? [String]()
        
        DispatchQueue.main.async {
            self.read = self.readContainer
        }
    }
    
    func nullifyBadge() {
        let number = Int(self.badgeValue ?? "0")
        
        if number ?? 0 < 1 {
            DispatchQueue.main.async {
                self.badgeValue = nil
            }
        }
    }
}

private class NetworkConnection: ObservableObject {
    @Published var connected: Bool = false
    
    init() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.connected = false

                }
            }
            else {
                DispatchQueue.main.async {
                    self.connected = true
                }   
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
