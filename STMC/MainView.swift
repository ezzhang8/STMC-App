//
//  MainView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-19.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import UIKit
import Network

struct MainView: View {
    @EnvironmentObject var userStatus: Profile
    @ObservedObject fileprivate var network = NetworkConnection()
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.TBRC)
       // self.checkConnection()
    }
    
    var alert: Alert {
        Alert(title: Text("No connection"), message: Text("STMC requires access to Wi-Fi or cellular data to update information. Some information may be outdated or inaccessible without a network connection."), dismissButton: .default(Text("OK")))
    }

    var body: some View {
        TabView {
            ScheduleTab()
                .environmentObject(userStatus)
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Schedule")
                }

            ExploreTab()
                .environmentObject(userStatus)
                .tabItem {
                    Image(systemName: "rectangle.3.offgrid.fill")
                    Text("Explore")
                }
            ResourcesTab()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Resources")
                }
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(.STMC)
        .alert(isPresented: $network.connected, content: {self.alert})
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
