//
//  HouseDetails.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-15.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct HouseDetails: View {
    @Environment(\.presentationMode) private var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    @State private var selectorIndex: Int = 0
    var house: House
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            GeometryReader{reader in
                if reader.frame(in: .global).minY > -280 {
                    Image(house.houseName + "-bg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 360 : 360)
                }
               
            }
            .frame(height: 300)
                
            VStack (alignment: .leading){
                VStack(alignment: .center) {
                    Image(house.houseName)
                        .resizable()
                        .frame(width: 256, height: 256)
                        .shadow(radius: 8)
                    Text(house.houseName)
                        .font(.system(size: 35, weight: .bold))
                    
                    Text(String(house.points)+" pts.")
                        .font(.headline)
                    
                    //Picker(selection:$selectorIndex, label: Text("Picker")) {
                        //Text("Advisories").tag(0)
                       // Text("Points").tag(0)
                    //}
                    //.padding(.horizontal, 25)
                    //.padding(.vertical)
                    //.pickerStyle(SegmentedPickerStyle())
                    
                    
                 
                        PointsView(idHouse: house.id)
                    
                }
            }
            .padding(.top, 50)
            .frame(width: UIScreen.main.bounds.width)
            //.background(Blur(style: .systemThinMaterial))

            .background(Color.GR)
            .cornerRadius(20)
            .offset(y: -72)
        })
        
        .background(Color.GR.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
    }
}

struct AdvisoriesView: View {
    var idHouse: Int
    @ObservedObject fileprivate var advisories: Advisories
    
    init(idHouse: Int) {
        advisories = Advisories(idHouse: idHouse)
        self.idHouse = idHouse
    }
    
    var body: some View {
        VStack {
            ForEach(advisories.data, id: \.self) { i in
                AdvisoryCard(advisoryId: String(i.id), room: i.room, teachers: i.teachers)
            }
        }
    }
}

struct PointsView: View {
    var idHouse: Int
    @ObservedObject fileprivate var points: Points
    
    init(idHouse: Int) {
        points = Points(idHouse: idHouse)
        self.idHouse = idHouse
    }
    var body: some View {
        VStack {
            ForEach(points.data, id: \.self) { i in
                PointsCard(points: i.points, date: i.date, action: i.action)
            }
        }
    }
}

private struct Advisory: Identifiable, Hashable {
    var id: Int
    var room: String
    var teachers: String
}

private struct PointEntry: Hashable, Codable {
    var action: String
    var date: String
    var points: Int
}

private class Points: ObservableObject {
    @Published var data = [PointEntry]()
    
    init(idHouse: Int) {
        sendRequest(url: String(API.url+"points/"+String(idHouse)), completion: { json in
            let error = json["error"].string

            if error != nil {
                DispatchQueue.main.async {
                    if let cachedData = UserDefaults.standard.data(forKey: "PointsData"+String(idHouse)) {
                        self.data = try! PropertyListDecoder().decode([PointEntry].self, from: cachedData)
                    }
                }
                return
            }
            let pointEntries = json.array!.reversed()
            
            var pointContainer = [PointEntry]()
            for entry in pointEntries {
                let date = entry["date"].stringValue.prefix(10)
                let action = entry["action"].stringValue
                let points = entry["points"].intValue
                
                pointContainer.append(PointEntry(action: action, date: String(date), points: points))
                
                

            }
            DispatchQueue.main.async {
                self.data = pointContainer
                if let cachedArray = try? PropertyListEncoder().encode(pointContainer) {
                    UserDefaults.standard.set(cachedArray, forKey: "PointsData"+String(idHouse))
                }
            }
        })
    }
}

private class Advisories: ObservableObject {
    @Published var data = [Advisory]()
    
    init(idHouse: Int) {
        sendRequest(url: String(API.url+"advisories/"), completion: { json in
            let advisories = json.array!
            
            for advisory in advisories {
                var advisoryId = advisory["advisoryId"].intValue
                
                // Ignore the advisories not part of this house.
                if advisoryId > 10*idHouse && advisoryId < 10*idHouse + 10 {
                    let roomNumber = String(advisory["roomNumber"].intValue)
                    let teachers = [advisory["teacher1"].stringValue, advisory["teacher2"].stringValue, advisory["teacher3"].stringValue]
                    // Replace certain integer codes with room names.
                    let roomReplacements = [
                        "100": "Gym",
                        "150": "Cafeteria",
                        "200": "Multipurpose Room",
                        "201": "Library"
                    ]
                    var teacherString: String = ""
                    var roomString: String
                    
                    if roomReplacements[roomNumber] != nil {
                        roomString = roomReplacements[roomNumber] ?? "Error"
                    }
                    else {
                        roomString = "Room "+String(roomNumber)
                    }
                    // Subtract 10 times the house id to retrieve the advisory number that the user will understand.
                    advisoryId = advisoryId - (10*idHouse)
                    
                    // For each teacher in the array, generate a string that separates their names by a comma.
                    for teacher in teachers {
                        if teacher != "" && teacherString == "" {
                            teacherString += teacher
                        }
                        else if teacher != "" && teacherString != "" {
                            teacherString += ", " + teacher
                        }
                    }
                    DispatchQueue.main.async {
                        self.data.append(Advisory(id: advisoryId, room: roomString, teachers: teacherString))
                    }
                }
            }
        })
    }
}

struct HouseDetails_Previews: PreviewProvider {
    static var previews: some View {
        HouseDetails(house: House(id: 1, houseName: "Canterbury", points: 32))
    }
}
