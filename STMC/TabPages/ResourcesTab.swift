//
//  ResourcesTab.swift
//  STMC
//
//  Created by Eric Zhang on 2020-05-26.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct ResourcesTab: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    HStack {
                        Image(systemName: "link")
                            .resizable()
                            .frame(width:15, height:15)
                        Text("Links")
                            .font(.callout)
                            .fontWeight(.bold)
                            .textCase(.none)
                    }
                        
                ){
                    Button(action: {
                        openURL(URL(string: "https://stthomasmorecollegiate.ca")!)
                    }) {
                        HStack {
                            Image("STMC")
                                .resizable()
                                .frame(width:18, height:20)
                                .scaledToFit()
                            Text("STMC Website")
                        }
                    }
                    Button(action: {
                        openURL(URL(string: "https://moodle.stmc.bc.ca")!)
                    }) {
                        HStack {
                            Image("Moodle")
                                .resizable()
                                .frame(width:20, height:20)
                                .scaledToFit()
                            Text("Moodle")
                        }
                    }
                    Button(action: {
                        openURL(URL(string: "https://ps.stmc.bc.ca")!)
                    }) {
                        HStack {
                            Image("PowerSchool")
                                .resizable()
                                .frame(width:20, height:20)
                                .scaledToFit()
                            Text("PowerSchool")
                        }
                    }

                    
                }
                
                Section {
                    Button(action: {
                        openURL(URL(string: "https://sites.google.com/stmc.bc.ca/learningcommons")!)
                    }) {
                        HStack {
                            Image("STMC")
                                .resizable()
                                .frame(width:18, height:20)
                                .scaledToFit()
                            Text("Learning Commons")
                        }
                    }
                    Button(action: {
                        openURL(URL(string: "https://sites.google.com/stmc.bc.ca/studentlife")!)
                    }) {
                        HStack {
                            Image("STMC")
                                .resizable()
                                .frame(width:18, height:20)
                                .scaledToFit()
                            Text("Student Life")
                        }
                    }
                    
                }
                Section (header:
                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .frame(width:12, height:15)
                        Text("Search")
                            .font(.callout)
                            .fontWeight(.bold)
                            .textCase(.none)
                    }
                ){
                    NavigationLink(destination: LockerView()) {
                        HStack {
                            Image(systemName: "lock.circle.fill")
                                .resizable()
                                .frame(width:20, height: 20)
                                .scaledToFit()
                            Text("Find Locker")
                        }
                    }
                    NavigationLink(destination: RoomView()) {
                        HStack {
                            Image(systemName: "textformat.123")
                                .resizable()
                                .frame(width:20, height: 10)
                                .scaledToFit()
                            Text("Find Room")
                        }
                    }
                }

            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Resources"))
            .accentColor(.LC)
//            .navigationBarItems(leading:
//                Button(action:{
//                }) {
//                    Image(systemName: "gear")
//                        .resizable()
//                        .accentColor(.STMC)
//                        .scaledToFit()
//                }
//                .frame(width: 30, height: 30)
//            )
        }
    }
}

struct ResourcesTab_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesTab()
    }
}
