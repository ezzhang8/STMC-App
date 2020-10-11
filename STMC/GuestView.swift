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
