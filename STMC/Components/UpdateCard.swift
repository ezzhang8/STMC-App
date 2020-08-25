//
//  UpdateCard.swift
//  STMC
//
//  Created by Eric Zhang on 2020-07-17.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct UpdateCard: View {
    var id:Int
    var title:String
    var style:String
    var styles = [
        "warning": [Color.orange, "exclamationmark.triangle.fill"],
        "alert": [Color.red, "exclamationmark.circle.fill"],
        "notice": [Color.gray, "info.circle.fill"]
    ]
    var body: some View {
        NavigationLink(destination: TicketView()) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 45)
                    .foregroundColor(styles[style]![0] as? Color)
                VStack {
                    HStack {
                        Image(systemName: styles[style]![1] as! String)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 10, height:18)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10.0)
                    .frame(alignment: .center)
                        
                }
            }
        }
        .padding(.horizontal)
        .shadow(radius: 5)
        .buttonStyle(ScaleButtonStyle())

    }
}

struct UpdateCard_Previews: PreviewProvider {
    static var previews: some View {
        UpdateCard(id: 0, title: "Test", style: "warning")
    }
}
