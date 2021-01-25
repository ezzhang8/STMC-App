//
//  LockerView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-21.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI



struct LockerView: View {
    @State private var locker: String = ""
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            Divider()
            VStack (alignment: .center) {
                if (colorScheme == .dark) {
                    Image("Locker")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .colorInvert()

                }
                else {
                    Image("Locker")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                
                Text("Find directions to any locker in the school.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(height: 20)
                TextField("Enter Locker #", text: $locker)
                   // .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.TBRC)
                    .cornerRadius(15)
                Text(generateLockerDirections(locker: Int(locker) ?? 0))
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
                    .frame(height: 100)
            }
            .padding(.horizontal, 35)
            .padding(.top)
            .navigationBarTitle(Text("Lockers"))
        }
        .background(Color.GR.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

private func generateLockerDirections(locker: Int)-> String {
    let lockerDict = [
        [1, 46, "Locker \(String(locker)) is located in the PE wing, between the PE office and the maintenance room."],
        [47, 88, "Locker \(String(locker)) is located in the PE wing, on the side of the workshop."],
        [89, 132, "Locker \(String(locker)) is located between the staff room and room 115."],
        [133, 180, "Locker \(String(locker)) is located by room 115."],
        [181, 216, "Locker \(String(locker)) is located by room 119."],
        [217, 252, "Locker \(String(locker)) is located by room 121."],
        [253, 288, "Locker \(String(locker)) is located by room 123."],
        [289, 324, "Locker \(String(locker)) is located by room 132."],
        [399, 432, "Locker \(String(locker)) is located by stairway 4 (middle of the main hallway) on the second floor."],
        [483, 504, "Locker \(String(locker)) is located by stairway 2 (near room 212) on the second floor."],
        [505, 540, "Locker \(String(locker)) is located outside room 212."],
        [541, 576, "Locker \(String(locker)) is located by room 226."],
        [577, 612, "Locker \(String(locker)) is located by room 224."],
        [613, 628, "Locker \(String(locker)) is located by room 222."],
        [629, 670, "Locker \(String(locker)) is located between room 220 and room 222."],
        [671, 686, "Locker \(String(locker)) is located by room 222, near the boys' washroom."],
        [687, 694, "Locker \(String(locker)) is located outside the library, near the girls' washroom."],
        [695, 720, "Locker \(String(locker)) is located by room 127."],
        [721, 742, "Locker \(String(locker)) is located by room 129."],
        [743, 766, "Locker \(String(locker)) is located by room 131."],
        [721, 742, "Locker \(String(locker)) is located by room 129."],
        [767, 812, "Locker \(String(locker)) is located outside the choir room, room 225."],
        [813, 836, "Locker \(String(locker)) is located outside the band room, room 229."],
    ]
    
    for lockerRange in lockerDict {
        if (locker >= lockerRange[0] as! Int && locker <= lockerRange[1] as! Int) {
            return lockerRange[2] as! String
        }
    }
    
    return ""
}

struct LockerView_Previews: PreviewProvider {
    static var previews: some View {
        LockerView()
    }
}
