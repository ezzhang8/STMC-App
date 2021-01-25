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
                        LinearGradient(gradient: houseGradient[house.houseName] ?? houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                     )
                     .frame(width: 125, height: 175)
                 VStack(alignment: .center){
                     Spacer()
                    Image(house.houseName)
                         .resizable()
                         .frame(width: 128, height: 128)
                         .shadow(radius: 8)
                    VStack {

                        Text(String(house.points) + " pts.")
                             .font(.subheadline)
                             .fontWeight(.bold)
                             .foregroundColor(Color.white)
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

struct HouseCardView: View {
    var house: House
    var animation: Namespace.ID
    var body: some View {
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
                     .matchedGeometryEffect(id: house.houseName, in: animation)

                VStack {

                    Text(String(house.points) + " pts.")
                         .font(.subheadline)
                         .fontWeight(.bold)
                         .foregroundColor(Color.white)
                        .padding(.bottom)
                     
                 }
                 .frame(width: 175)
             }
             .frame(width: 50.0, height: 50.0)
        }
        .buttonStyle(ScaleButtonStyle())

    }
}
