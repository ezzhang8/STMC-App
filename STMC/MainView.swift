//
//  MainView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-19.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import UIKit


struct MainView: View {
    @EnvironmentObject var userStatus: Profile

    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.TBRC)
       // UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        //UITabBar.appearance().clipsToBounds = true
    }

    var body: some View {
        TabView {
            ScheduleTab()
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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
