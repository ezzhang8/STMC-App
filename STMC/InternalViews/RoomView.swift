//
//  RoomView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-21.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct RoomView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ScrollView {
            Divider()
            Section(header:
                HStack {
                    Image(systemName: "1.circle.fill")
                        .resizable()
                        .frame(width: 20, height:20)
                    Text("1st Floor")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    
                }
                .padding(.leading)
            ) {
                if (colorScheme == .dark) {
                    Image("Floor1")
                        .resizable()
                        .aspectRatio(UIImage(named: "Floor1")!.size, contentMode: .fit)
                        .colorInvert()
                        .frame(width: UIScreen.main.bounds.width)

                }
                else {
                    Image("Floor1")
                        .resizable()
                        .aspectRatio(UIImage(named: "Floor1")!.size, contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width)
                }
            }
            Divider()
            Section(header:
                HStack {
                    Image(systemName: "2.circle.fill")
                        .resizable()
                        .frame(width: 20, height:20)
                    Text("2nd Floor")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading)
            ) {
                if (colorScheme == .dark) {
                    Image("Floor2")
                        .resizable()
                        .aspectRatio(UIImage(named: "Floor2")!.size, contentMode: .fit)
                        .colorInvert()
                        .frame(width: UIScreen.main.bounds.width)

                }
                else {
                    Image("Floor2")
                        .resizable()
                        .aspectRatio(UIImage(named: "Floor2")!.size, contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width)
                }
            }
            .navigationBarTitle(Text("Classrooms"))
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView()
    }
}
