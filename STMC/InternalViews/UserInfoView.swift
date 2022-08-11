//
//  UserInfoView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-20.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct UserInfoView: View {
    @EnvironmentObject var userStatus: Profile
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationView {
            List {
                Section(header:
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.primary)
                        Text("Profile")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }
                        
                ){
                    VStack (alignment: .leading){
                        Text((userStatus.user?.profile.name) ?? "Name")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text((userStatus.user?.profile.email) ?? "Email" )
                    }
                    .padding(.vertical, 5)
                }
                
                Section(header:
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.primary)
                        Text("About")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }
                ){
                    VStack (alignment: .leading){
                        Text("STMC App for iOS")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Developed and coded by Eric Zhang ('22)")
                            .font(.subheadline)
                        Text("House crests designed by Charlotte Cho ('21)")
                            .font(.subheadline)
                        Text("Calendar API by Philip Stachura ('19)")
                            .font(.subheadline)
                        Text("Special thanks to STMC staff: Mr. Garland, Ms. Lauang, Mr. Olson")
                            .font(.subheadline)
                            .font(.caption)
                            .padding(.top, 5)
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Image(systemName: "hand.raised")
                            .resizable()
                            .frame(width: 12, height: 15)
                            .foregroundColor(.STMC)
                        Link("Privacy Policy", destination: URL(string: "https://app.stmc.bc.ca/privacy.php")!)
                            .foregroundColor(.STMC)
                        
                    }
                }
                
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                        GIDSignIn.sharedInstance().signOut()
                        userStatus.clear()
                    }
                }) {
                    Text("Log Out")
                        .accentColor(.STMC)
                }
               
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("My Account"))
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
        .font(.body)
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
