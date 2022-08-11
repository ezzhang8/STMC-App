//
//  HouseDetails.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-15.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct HouseDetails : View {
    @Environment(\.presentationMode) private var presentationMode

    @GestureState private var dragOffset = CGSize.zero
    
    var house: House
    
    @ObservedObject fileprivate var points: Points
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var show = false
    
    init(house: House) {
        self.house = house
        self.points = Points(idHouse: house.id)
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    GeometryReader { g in
                        ZStack {
                            if g.frame(in: .global).minY > -500 {
                                Image(house.houseName + "-bg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height:  360)
                                    .onReceive(self.time) { (_) in
                                        let y = g.frame(in: .global).minY
                                        
                                        if -y > (UIScreen.main.bounds.height / 2.2) - 50{
                                            withAnimation {
                                                self.show = true
                                            }
                                        }
                                        else {
                                            withAnimation () {
                                                self.show = false
                                            }
                                        }
                                    }
                            }
                            Image(house.houseName)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .shadow(radius: 8)
                                .offset(y:-10)
                        }
                    }
                    .frame(height: 300)
                    VStack (alignment: .leading){
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.primary)
                                    .padding(.leading)
                                Text("Points")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                            }
                            
                            VStack(spacing: 10) {
                                if (points.data.count > 0) {
                                    ForEach(points.data, id: \.self) { i in
                                        PointsCard(entry: i, houseName: house.houseName)
                                    }
                                }
                                else {
                                    Text("No points to display yet.")
                                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 10)
                                        .padding(.horizontal, 20)
                                        .lineLimit(nil)

                                }
                                
                            }
                            Spacer()
                                .frame(minHeight: 20, maxHeight: 50)
                        }
                    }
                    .padding(.top, 20)
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.GR)
                    .cornerRadius(20)
                    .offset(y: -25)

                        
                }
            })
            if self.show {
                GeometryReader { geometry in
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .center){
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                    
                                    print(geometry.safeAreaInsets)
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                .accentColor(houseColors[house.houseName])
                                .padding(.leading, 15)
                                Image(house.houseName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                
                            }
                        }
                        Text(house.houseName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                        Text(String(house.points) + " pts.")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .background(LinearGradient(gradient: houseGradient[house.houseName] ?? houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading))
                            .clipShape(Capsule())
                    }
                    .padding(.top, geometry.safeAreaInsets.bottom < 83 ? 25 : 40)
                    .padding(.trailing)
                    .padding(.bottom)
                    .background(BlurBG())
                }
            }
        })
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .background(Color.GR.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct BlurBG : UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView{
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct PointEntry: Hashable, Codable {
    let action: String
    let description: String?
    let date: String
    let points: Int
    let dateFull: String
    let approvedBy: String


}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

private class Points: ObservableObject {
    @Published var data = [PointEntry]()
    
    init(idHouse: Int) {
        sendRequest(url: String(API.url+"points/"+String(idHouse)), completion: { json in
            let error = json["error"].string

            if error != nil {
                if let cachedData = UserDefaults.standard.data(forKey: "PointsData"+String(idHouse)) {
                    DispatchQueue.main.async {
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
                let dateFull = entry["date"].stringValue
                let approvedBy = entry["approvedBy"].stringValue
                let description = entry["description"].string
                
                pointContainer.append(PointEntry(action: action, description: description, date: String(date), points: points, dateFull: dateFull, approvedBy: approvedBy))
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

