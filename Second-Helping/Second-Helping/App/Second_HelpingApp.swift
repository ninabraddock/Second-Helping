//
//  Second_HelpingApp.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/24/24.
//

import SwiftUI
import Firebase

class LoadingState: ObservableObject {
    @Published var isLoading: Bool = false
}

@main
struct Second_HelpingApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var restaurantViewModel = RestaurantViewModel()
    @StateObject var loadingState = LoadingState()
    @State var isLoggedIn = false
    @State var isCustomer = true
    @State var isRestaurant = false

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn, isCustomer: $isCustomer, isRestaurant: $isRestaurant)
                .environmentObject(authViewModel)
                .environmentObject(restaurantViewModel)
                .environmentObject(loadingState)
        }
    }
}
