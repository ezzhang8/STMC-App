//
//  PointsCard.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-16.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct PointsCard: View {
    var points: Int
    var date: String
    var action: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                .frame(height: 60)
                
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(action)
                            .font(.system(size: 18, weight: .semibold))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text(date)
                            .font(.system(size: 14, weight: .medium))
                    }
                    Spacer()
                    Text("+"+String(points))
                        .font(.system(size: 24, weight: .heavy))
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .frame(alignment: .center)
                    
            }
        }
        .padding(.horizontal)
    }
}

struct PointsCard_Previews: PreviewProvider {
    static var previews: some View {
        PointsCard(points: 32, date: "2020-08-16", action: "Preview Placeholder")
        
    }
}
