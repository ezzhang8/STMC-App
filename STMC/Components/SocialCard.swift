//
//  SocialCard.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-23.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct SocialCard: View {
    var imageName: String
    var link: String
    @Environment(\.openURL) var openURL

    var body: some View {
        Button(action:{openURL(URL(string: link)!)}) {

            ZStack(alignment: .center) {
                 RoundedRectangle(cornerRadius: 15)
                     .fill(
                         LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading)
                     )
                     .frame(width: 100, height: 100)
                 VStack(alignment: .center){
                      Image(imageName)
                        .resizable()
                        .scaledToFit()
                    
                 }
                 .frame(width: 60, height: 60)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
