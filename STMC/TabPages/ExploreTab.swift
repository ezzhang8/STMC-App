//
//  ExploreTab.swift
//  STMC
//
//  Created by Eric Zhang on 2020-05-04.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import GoogleSignIn

struct ExploreTab: View {
    @EnvironmentObject var userStatus: Profile

    @State private var showingUser: Bool = false

    @ObservedObject fileprivate var houses = Houses()
    @ObservedObject fileprivate var bulletins = Bulletins()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading) {
                    Divider()
                    Section(header:
                        HStack {
                            Image(systemName: "shield.lefthalf.fill")
                                .resizable()
                                .frame(width: 20, height:22)
                            Text("Houses")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            
                        }
                        .padding(.leading)
                    ) {
                        ScrollView (.horizontal, showsIndicators: false){
                            HStack(spacing: 10) {
                                ForEach(houses.houseData, id: \.self) { house in
                                    HouseCard(house: house)
                                }
                                
                                Spacer()
                                .frame(width: 8)
                            }
                            .padding([.leading, .bottom])
                        }
                    }
                    Divider()
                    Section(header:
                        HStack {
                            Image(systemName: "pin")
                                .resizable()
                                .frame(width: 18, height: 25)
                            Text("Bulletin")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                        }
                        .padding(.leading)
                    ) {
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                if bulletins.bulletinData.count == 0 {
                                    Text("No bulletins to display")
                                } else {
                                    ForEach(bulletins.bulletinData, id: \.self) { bulletin in
                                        BulletinCard(bulletin: bulletin)
                                    }
                                }
                               

                            }
                            .padding([.horizontal, .bottom])
                        }
                    }
                
                Divider()
                Section(header:
                    HStack {
                        Image(systemName: "app.badge")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Social Media")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                    }
                    .padding(.leading)
                ) {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            SocialCard(imageName: "Instagram", link: "https://instagram.com/stmcknights")
                            SocialCard(imageName: "Twitter", link: "https://twitter.com/stmc/burnaby")
                            SocialCard(imageName: "Facebook", link: "https://www.facebook.com/StThomasMoreCollegiate/")
                            SocialCard(imageName: "STMC", link: "https://stthomasmorecollegiate.ca/news-media/")

                            
                        }
                        .padding([.horizontal, .bottom])
                    }
                }
            }
            .navigationBarTitle(Text("Explore"))
            .navigationBarItems(leading:
                Button(action:{
                    GIDSignIn.sharedInstance().signOut()
                    self.showingUser.toggle()
                }) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .accentColor(.STMC)
                        .frame(width: 25, height: 25)

                }
                .frame(width: 25, height: 45)
                .sheet(isPresented: $showingUser) {
                    UserInfoView()
                        .environmentObject(userStatus)
                })
            }
            .background(Color.GR.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        }
    }
}


struct House : Identifiable, Hashable, Codable {
    var id: Int
    var houseName: String
    var points: Int
}

struct Bulletin: Identifiable, Hashable {
    var id: Int
    var name: String
    var dateAdded: String
    var description: String
    var imageLink: String
    var webLink: String
}

private class Houses: ObservableObject {
    @Published var houseData = [House]()
    
    init() {
        sendRequest(url: String(API.url+"houses/"), completion: { json in
            let error = json["error"].string

            if error == "The Internet connection appears to be offline."  {
                DispatchQueue.main.async {
                    if let cachedData = UserDefaults.standard.data(forKey: "HouseData") {
                        self.houseData = try! PropertyListDecoder().decode([House].self, from: cachedData)
                    }
                }
                return
            }
            let houseStandings = json.array!
            
            var houseContainer = [House]()
            
            for house in houseStandings {
                let houseId = house["houseId"].intValue
                let houseName = house["houseName"].stringValue
                let points = house["points"].intValue
                
                houseContainer.append(House(id: houseId, houseName: houseName, points: points))
                houseContainer.sort {
                    $0.points > $1.points
                }
            }
            
            DispatchQueue.main.async {
                self.houseData = houseContainer
                if let cachedArray = try? PropertyListEncoder().encode(houseContainer) {
                    UserDefaults.standard.set(cachedArray, forKey: "HouseData")
                }
            }
            
          
        })
    }
}

private class Bulletins: ObservableObject {
    @Published var bulletinData = [Bulletin]()
    
    init() {
        sendRequest(url: String(API.url+"bulletin/"), completion: { json in
            let error = json["error"].string

            if error != nil {
                return
            }
            let bulletins = json.array!
            
            for bulletin in bulletins {
                let id = bulletin["bulletinId"].intValue
                let dateAdded = bulletin["dateAdded"].stringValue
                let name = bulletin["name"].stringValue
                let description = bulletin["description"].stringValue
                let imageLink = bulletin["imageLink"].stringValue
                let webLink = bulletin["webLink"].stringValue
                
                DispatchQueue.main.async {
                    self.bulletinData.append(Bulletin(id: id, name: name, dateAdded: dateAdded,  description: description, imageLink: imageLink, webLink: webLink))
                }
            }
        })
    }
}




struct ExploreTab_Previews: PreviewProvider {
    static var previews: some View {
        ExploreTab()
    }
}
