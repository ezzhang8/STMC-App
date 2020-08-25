//
//  ContentView.swift
//  STMC
//
//  Created by Eric Zhang on 2019-11-24.
//  Copyright © 2019 Eric Zhang. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var userStatus: Profile
    var body: some View {
        if self.userStatus.user == nil {
            ZStack {
                VStack(alignment: .center){
                    Image("STMC")
                        .resizable()
                        .frame(width: 64, height: 64)
                    Text("Sign in with your mySTMC Account")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    HStack(alignment: .center) {
                        Spacer()
                       // SignInView()
                            //.frame(width: 80)
                        LogInButton()
                            .padding(.top, 10)
                        Spacer()
                    }
                    
                }
                .padding(.vertical, 50)
                .background(Blur(style: .systemThinMaterial))
                .cornerRadius(20)
                .shadow(radius: 10)
            }
            .background(Image("HomePlaceholder"))
            .padding(.horizontal)
        }
        else {
            MainView()
                .environmentObject(userStatus)
        }
        
    }
}

struct Blur: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
