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
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                    )
                    .frame(width: 225, height: 125)
                VStack(alignment: .center){
                    Text(bulletin.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                      //  .truncationMode(.head)
                    Text(formatDate(dateString: bulletin.dateAdded))
                        .font(.footnote)
                        .fontWeight(.light)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 110)
               // .padding(.all)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
