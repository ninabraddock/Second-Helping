//
//  AppDelegate.swift
//  Second-Helping
//
//  Created by Charlie Corriero on 10/2/24.
//

import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // This method is called when the app has completed launching
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase when the app launches
        FirebaseApp.configure()
        return true
    }
}
