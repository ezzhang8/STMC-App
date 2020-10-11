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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    var body: some View {
        NavigationView {
            List {
                Section(header:
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Profile")
                            .font(.callout)
                            .fontWeight(.bold)
                            .textCase(.none)
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
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 20, height: 15)
                        Text("Contact")
                            .font(.callout)
                            .fontWeight(.bold)
                            .textCase(.none)
                    }
                        
                ){
                    VStack (alignment: .leading){
                        Text("St. Thomas More Collegiate")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("7450 12th Avenue")
                        Text("Burnaby, BC V3N 2K1")
                        
                        
                        
                        
                    }
                    .padding(.vertical, 5)
                    HStack {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.STMC)

                        
                        Link("604-521-1801", destination: URL(string: "tel:6045211801")!)
                            .foregroundColor(.STMC)
                        
                    }
                    HStack {
                        Image(systemName: "safari")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.STMC)
                        Link("stmc.bc.ca", destination: URL(string: "https://stmc.bc.ca")!)
                            .foregroundColor(.STMC)
                        
                    }

                }
                Section(header:
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("About")
                            .font(.callout)
                            .fontWeight(.bold)
                            .textCase(.none)
                    }
                        
                ){
                    VStack (alignment: .leading){
                        Text("STMC App for iOS")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Developed and coded by Eric Zhang")
                            .font(.subheadline)
                        Text("House crests designed by Charlotte Cho")
                            .font(.subheadline)
                        Text("Calendar API by Philip Stachura")
                            .font(.subheadline)
                        Text("Special thanks to STMC staff: Mr. Beadon, Mr. Garland, Ms. Lauang, Mr. Olson")
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
                    GIDSignIn.sharedInstance().signOut()
                    userStatus.clear()
                    self.presentationMode.wrappedValue.dismiss()
                    
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
