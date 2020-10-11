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
            Text("To access all features of the STMC App, please exit Guest Mode and sign in with a school account.")
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
    init() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
    }
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
