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
    @State private var showingCourses: Bool = false
    
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
                            Text(houses.getLead())
                                .fontWeight(.semibold)
                                .foregroundColor(houses.getLeadingHouseColor())
                                .padding(.trailing)
                            
                        }
                        .padding(.leading)
                    ) {
                        ScrollView (.horizontal, showsIndicators: false){
                            VStack {
                                HStack(spacing: 10) {
                                    if (houses.houseData.count == 0) {
                                        HStack {
                                            Spacer()
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle())
                                                .frame(width: 50, height: 50)
                                            Spacer()

                                        }
                                    }
                                    ForEach(houses.houseData, id: \.self) { house in
                                        HouseCard(house: house)
                                    }
                                    
                                    Spacer()
                                    .frame(width: 8)
                                }
                                .padding([.leading, .bottom])
                                
                            }
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
                                BulletinHouseCard(bulletin: Bulletin(id: 19389318, name: "This is a much longer title!", dateAdded: "2020-01-02", description: "This is a test description that is much much longer lorem ipsum lolo lflan fndsfn  fdf d fdjfdjfd fdfndjf djkf djkf djk", imageLink: nil, webLink: "https://google.com", house: "Canterbury"))

                            }
                            .padding([.horizontal, .bottom])
                        }
                    }
                    Divider()
                    Section(header:
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 20, height: 25)
                            Text("Find")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                        }
                        .padding(.leading)
                    ) {
                    
                    }
            }
            .navigationBarTitle(Text("Explore"))
            .navigationBarItems(leading:
                Button(action:{
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
    var imageLink: String?
    var webLink: String?
    var house: String?
}

private class Houses: ObservableObject {
    @Published var houseData = [House]()
    
    init() {
        sendRequest(url: String(API.url+"houses/"), completion: { json in
            let error = json["error"].string

            if error != nil  {
                if let cachedData = UserDefaults.standard.data(forKey: "HouseData") {
                    DispatchQueue.main.async {
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
    
    func getLead() -> String {
        if self.houseData.count > 2 {
            return self.houseData[0].houseName + " +" + String(self.houseData[0].points - self.houseData[1].points) + " pts."
        }
        return ""
    }
    
    func getLeadingHouseColor() -> Color {
        if self.houseData.count > 2 {
            return houseColors[self.houseData[0].houseName] ?? Color.STMC
        }
        return Color.STMC
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
            let bulletins = json.array!.reversed()
            
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
