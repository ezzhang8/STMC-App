//
//  BulletinCard.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-22.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct BulletinCard: View {
    var bulletin: Bulletin
    
    var body: some View {
        NavigationLink(destination:BulletinView(bulletin: bulletin)) {
            ZStack {
                Image("STMC")
                     .resizable()
                     .frame(width: 110, height: 128)
                     .shadow(radius: 8)
                        .opacity(0.3)
                    .offset(x: -50, y: 40)
                VStack(alignment: .center){
                    Text(bulletin.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .truncationMode(.tail)
                    Capsule()
                        .foregroundColor(Color.white)
                        .frame(width: 120, height: 2)
                    Text(formatDate(dateString: bulletin.dateAdded))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .font(.system(.subheadline, design: .rounded))

                }
                .frame(width: 220, height: 130)
                .padding(.horizontal, 10)
            }
            .background(
                LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct BulletinHouseCard: View {
    var bulletin: Bulletin
    var body: some View {
        NavigationLink(destination:BulletinHouseView(bulletin: bulletin)) {
            ZStack {
                Image(bulletin.house!)
                     .resizable()
                     .frame(width: 128, height: 128)
                     .shadow(radius: 8)
                        .opacity(0.3)
                    .offset(x: -50, y: 40)
                VStack(alignment: .center){
                    Text(bulletin.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .truncationMode(.tail)
                    Capsule()
                        .foregroundColor(Color.white)
                        .frame(width: 120, height: 2)
                    Text(formatDate(dateString: bulletin.dateAdded))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .font(.system(.subheadline, design: .rounded))

                }
                .padding(.horizontal, 10)
                .frame(width: 220, height: 130)
            }
            .background(
                LinearGradient(gradient: houseGradient[bulletin.house!]!, startPoint: .bottomTrailing, endPoint: .topLeading)
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
