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
                    Text("Profile")
                        .font(.callout)
                        .fontWeight(.bold)
                        .textCase(.none)
                        
                ){
                    VStack (alignment: .leading){
                        Text((userStatus.user?.profile.name) ?? "Name")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text((userStatus.user?.profile.email) ?? "Email" )
                    }
                    .padding(.vertical)
                }
                Section(header:
                    Text("About")
                        .font(.callout)
                        .fontWeight(.bold)
                        .textCase(.none)
                        
                ){
                    VStack (alignment: .leading){
                        Text("STMC App")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Developed by Eric Zhang ('22)")
                        Text("Special thanks to Philip Stachura ('19), for his work with the Google Calendar API")
                            .font(.caption)
                            .padding(.top, 5)
                    }
                    .padding(.vertical)
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
