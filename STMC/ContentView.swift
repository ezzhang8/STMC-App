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
    @EnvironmentObject var guestMode: GuestMode
    var body: some View {
        if self.userStatus.user?.profile.name == nil && self.guestMode.enabled == false {
            ZStack {
                VStack(alignment: .center){
                    Image("STMC")
                        .resizable()
                        .frame(width: 58, height: 64)
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
                    Button(action: {
                        self.guestMode.enabled(bool: true)
                    }) {
                        Text("Use in Guest Mode")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 30)
                            .background(Color.gray)
                            .cornerRadius(30)
                    }
                    Link("Privacy Policy", destination: URL(string: "https://app.stmc.bc.ca/privacy.php")!)
                        .padding(.top, 10)
                }
                .padding(.vertical, 50)
                .background(Blur(style: .systemThinMaterial))
                .cornerRadius(20)
                .shadow(radius: 10)
            }
            .background(Image("HomePlaceholder"))
            .padding(.horizontal)
        }
        else if self.guestMode.enabled == true {
            GuestView()
                .environmentObject(self.guestMode)
        }
        else {
            MainView()
                .environmentObject(userStatus)
        }
        
    }
}
class GuestMode: ObservableObject {
    @Published var enabled: Bool
    init(enabled: Bool) {
        self.enabled = enabled
    }
    
    func enabled(bool: Bool) {
        DispatchQueue.main.async {
            self.enabled = bool
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
