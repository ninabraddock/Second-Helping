//
//  Second_HelpingApp.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/24/24.
//

import SwiftUI
import Firebase

@main
struct Second_HelpingApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var restaurantViewModel = RestaurantViewModel()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(restaurantViewModel)
        }
    }
}
