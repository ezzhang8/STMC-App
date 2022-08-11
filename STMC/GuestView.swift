//
//  GuestView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-10-10.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct GuestView: View {
    @EnvironmentObject var guestMode: GuestMode

    var body: some View {
        TabView {
            ScheduleTab()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Schedule")
                }
            NavigationView {
                RoomView()
            }
                .tabItem {
                    Image(systemName: "square.grid.3x1.below.line.grid.1x2")
                    Text("Classrooms")
                }
            NavigationView {

                LockerView()
            }
                .tabItem {
                    Image(systemName: "lock.circle.fill")
                    Text("Lockers")
                }
            SignInView()
                .environmentObject(guestMode)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                    Text("Sign In")
                }
            
            
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(.STMC)
    
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        GuestView()
    }
}
