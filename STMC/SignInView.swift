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
    var body: some View {
        SignInButton()
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

struct SignInButton: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<SignInButton>) -> GIDSignInButton {

        let button = GIDSignInButton()
        
//        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//
//        if var topController = keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            GIDSignIn.sharedInstance()?.presentingViewController = topController
//        // topController should now be your topmost view controller
//        }
        
        
        //print(UIApplication.shared.windows.first?.rootViewController)
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        return button
    }

    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<SignInButton>) {
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
