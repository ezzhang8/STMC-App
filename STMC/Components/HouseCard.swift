//
//  HouseCard.swift
//  STMC
//
//  Created by Eric Zhang on 2020-05-05.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct HouseCard: View {
    var house: House
    
    var body: some View {
        NavigationLink(destination:HouseDetails(house: house)) {

            ZStack(alignment: .center) {
                 RoundedRectangle(cornerRadius: 15)
                     .fill(
                         LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                     )
                     .frame(width: 125, height: 175)
                 VStack(alignment: .center){
                     Spacer()
                    Image(house.houseName)
                         .resizable()
                         .frame(width: 128, height: 128)
                         .shadow(radius: 8)
                    VStack {
//                        Text(house.houseName)
//                             .font(.headline)
//                             .fontWeight(.bold)
//                             .foregroundColor(Color.white)
//                             .multilineTextAlignment(.center)
//                             .lineLimit(14)
//                             .frame(width: 125)

                        Text(String(house.points) + " pts.")
                             .font(.subheadline)
                             .fontWeight(.semibold)
                             .foregroundColor(Color.yellow)
                            .padding(.bottom)
                         
                     }
                     .frame(width: 175)
                 }
                 .frame(width: 50.0, height: 50.0)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct HouseCard_Previews: PreviewProvider {
    static var previews: some View {
        HouseCard(house: House(id: 1, houseName: "Canterbury", points: 23))
    }
}
