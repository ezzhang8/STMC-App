//
//  AppDelegate.swift
//  STMC
//
//  Created by Eric Zhang on 2019-11-24.
//  Copyright © 2019 Eric Zhang. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleSignIn
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    // Initialize current user as nil.
    var userStatus = Profile(user: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "1044225247620-up37o5bjn8istsou9enlr9netj0hnsom.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
          
        OneSignal.initWithLaunchOptions(launchOptions,
            appId: "1e71fe3f-1946-42ca-9e77-956a87cb8b3c",
            handleNotificationAction: nil,
            settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Override point for customization after application launch.
        UIButton.appearance().isMultipleTouchEnabled = false
        UIButton.appearance().isExclusiveTouch = true

        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            }
            else if error.localizedDescription == "The user canceled the sign-in flow." {
                GIDSignIn.sharedInstance().signOut()
            }
            else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Updates the user status with the GIDGoogleUser received to log in. This object is then passed to the ContentView, which contains an Environment Object that helps to update the view.
        userStatus.updateUser(user: user)
        // The promptForPushNotifications function code will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 6)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
    }
}

class Profile: ObservableObject {
    @Published var user: GIDGoogleUser?
    
    init(user: GIDGoogleUser?) {
        self.user = user
    }
    
    func updateUser(user: GIDGoogleUser) {
        DispatchQueue.main.async {
            self.user = user
        }
    }
    func clear() {
        self.user = nil
    }
}
