//
//  PointsCard.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-16.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct PointsCard: View {
    @State var showDetails = false
    
    var entry: PointEntry
    var houseName: String
    
    var body: some View {
        Button (action: {
            self.showDetails.toggle()
        }) {
                    
                VStack {
                    if showDetails == false {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(entry.action)
                                    .font(.system(size: 18, weight: .semibold))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                        
                                
                                Text(entry.date)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            Spacer()
                            Text("+"+String(entry.points))
                                .font(.system(size: 24, weight: .heavy))
                            
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .frame(alignment: .center)
                    }
                    else {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(entry.action)
                                    .font(.system(size: 18, weight: .semibold))
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                if (entry.description != nil) {
                                    Text(entry.description!)
                                        .font(.system(size: 12, weight: .light))

                                }
                                Text(entry.dateFull)
                                    .font(.system(size: 14, weight: .medium))
                                
                                HStack {
                                    Text("Approved")
                                        .font(.system(size: 14, weight: .medium))
                                    Image(systemName: "checkmark.seal.fill")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                                .frame (height: 15)
                                

                            }
                            Spacer()
                            Text("+"+String(entry.points))
                                .font(.system(size: 24, weight: .heavy))
                            
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .frame(alignment: .center)

                    }
                //}
                
            }
            .background(LinearGradient(gradient: houseGradient[houseName] ?? houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal)
        .frame(maxWidth: UIScreen.main.bounds.width)

    }
}
