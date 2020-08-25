//
//  AdvisoryCard.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-16.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct AdvisoryCard: View {
    var advisoryId: String
    var room: String
    var teachers: String
    var body: some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                    )
                    .frame(height: 80)
                    
                VStack {
                    HStack {
                        Image(systemName: advisoryId+".circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        VStack(alignment: .leading) {
                            Text(room)
                                .font(.system(size: 18, weight: .semibold))
                            Text("Teachers:")
                                .italic()
                                .font(.system(size: 16, weight: .semibold))
                            Text(teachers)
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10.0)
                    .frame(alignment: .center)
                        
                }
            }
            .padding(.horizontal)
        }
    
}

struct AdvisoryCard_Previews: PreviewProvider {
    static var previews: some View {
        AdvisoryCard(advisoryId: "1", room: "Multipurpose Room", teachers: "Karryn Ransom, Ken Olson, Marian Eugine")
    }
}
