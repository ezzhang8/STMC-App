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
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .foregroundColor(Color.primary)
                        Text("Contact")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
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
                        Link("Website (stmc.bc.ca)", destination: URL(string: "https://stmc.bc.ca")!)
                            .foregroundColor(.STMC)
                        
                    }

                }
                Section(header:
                    HStack {
                        Image(systemName: "exclamationmark.square.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color.primary)
                        Text("Website Links")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }) {
                    Button(action: {
                        openURL(URL(string: "https://stthomasmorecollegiate.ca/about/policies-and-procedures/")!)
                    }) {
                        HStack {
                            VStack {
                                Circle()
                                    .frame(width:15, height: 15)
                                    .foregroundColor(Color.red)
                                    .padding([.top, .trailing], 8)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text("Policies and Procedures")
                                    .fontWeight(.bold)
                                Text("The webpage with all school policies and procedures.")
                            }
                        }
                    }
                    Button(action: {
                        openURL(URL(string: "https://stthomasmorecollegiate.ca/student-life/student-clubs-groups/")!)
                    }) {
                        HStack {
                            VStack {
                                Circle()
                                    .frame(width:15, height: 15)
                                    .foregroundColor(Color.red)
                                    .padding([.top, .trailing], 8)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text("Student Clubs & Groups")
                                    .fontWeight(.bold)
                                Text("Find a club to join and contact its teacher moderator.")
                            }
                        }
                    }
                    Button(action: {
                        openURL(URL(string: "https://stthomasmorecollegiate.ca/news-media/")!)
                    }) {
                        HStack {
                            VStack {
                                Circle()
                                    .frame(width:15, height: 15)
                                    .foregroundColor(Color.red)
                                    .padding([.top, .trailing], 8)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text("Social Media Feed")
                                    .fontWeight(.bold)
                                Text("Public STMC social media feed across Facebook, Twitter, and Instagram.")
                            }
                        }
                    }
                }
                Section(header:
                    HStack {
                        Image(systemName: "suit.heart.fill")
                            .resizable()
                            .frame(width: 17, height: 15)
                            .foregroundColor(Color.primary)
                        Text("Essentials")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }) {
                    Button(action: {
                        openURL(URL(string: "https://moodle.stmc.bc.ca")!)
                    }) {
                        HStack {
                            VStack {
                                Image("Moodle")
                                    .resizable()
                                    .frame(width:15, height: 15)
                                    .scaledToFit()
                                    .padding([.top, .trailing], 8)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text("Moodle")
                                    .fontWeight(.bold)
                                Text("A site used to share course notes and conduct online quizzes.")
                            }
                        }
                    }
                    Button(action: {
                        openURL(URL(string: "https://ps.stmc.bc.ca")!)
                    }) {
                        HStack {
                            VStack {
                                Image("PowerSchool")
                                    .resizable()
                                    .frame(width:15, height: 15)
                                    .scaledToFit()
                                    .padding([.top, .trailing], 8)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text("PowerSchool")
                                    .fontWeight(.bold)
                                Text("The official STMC student information system used to track grades, report cards, and attendance.")
                                    
                            }
                        }
                    }
                    Button(action: {
                        openURL(URL(string: "https://sites.google.com/stmc.bc.ca/learningcommons")!)
                    }) {
                        HStack {
                            VStack {
                                Image(systemName: "book")
                                    .resizable()
                                    .frame(width:15, height: 13)
                                    .scaledToFit()
                                    .foregroundColor(Color.red)
                                    .padding([.top, .trailing], 8)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                               
                                Text("Learning Commons")
                                    .fontWeight(.bold)

                                Text("The Learning Commons website has information and resources about reading, writing, and research.")
                                    
                            }
                        }
                    }
                }

            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Resources"))
            .accentColor(.LC)
        }
    }
}

struct ResourcesTab_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesTab()
    }
}
