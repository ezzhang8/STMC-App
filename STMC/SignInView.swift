//
//  SignInView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-19.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleSignIn

struct SignInView: View {
    @EnvironmentObject var guestMode: GuestMode

    var body: some View {
        VStack {
            Text("To access all features of the STMC App, please exit Guest Mode and sign in with a school account. For new students who haven't received an account yet, please sign in when you receive your credentials. For parents who would like to use additional features, please ask your child to sign in for you.")
                .fontWeight(.bold)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(action: {
                self.guestMode.enabled(bool: false)
            }) {
                Text("Exit Guest Mode")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                    .background(Color.STMC)
                    .cornerRadius(30)
            }
            .padding(.top, 10)
        }
      
    }
}

struct LogInButton: View {
//    init?() {
//        guard let keyWindow = UIApplication.shared.connectedScenes
//                
//                .filter({$0.activationState == .foregroundActive})
//                
//                .map({$0 as? UIWindowScene})
//                
//                .compactMap({$0})
//                
//                .first else { return nil }
//
//        let window = UIWindow(windowScene: keyWindow)
//        
//        
//         = window.rootViewController
//    }
    var body: some View {
        
        Button(action: {
            GIDSignIn.sharedInstance().signIn()
        }) {
            Text("Sign in with Google")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background(Color.blue)
                .cornerRadius(30)
        }
    }
}
