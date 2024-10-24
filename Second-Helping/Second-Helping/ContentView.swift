//
//  ContentView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/24/24.
//

import SwiftUI

struct ContentView: View {
//    @State private var isCustomer = true
//    @State private var isRestaurant = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                ProfileView()
            } else {
                LoginView()
                //                LoginView(isCustomer: $isCustomer, isRestaurant: $isRestaurant)
            }
        }
        
//        VStack {
//            if isCustomer {
//                CustomerView(isLoggedIn: $isCustomer)
//                    .transition(.slide)
//            } else if isRestaurant {
//                RestaurantView(isLoggedIn: $isRestaurant)
//                    .transition(.slide)
//            } else {
//                LoginView(isCustomer: $isCustomer, isRestaurant: $isRestaurant)
//                    .transition(.slide)
//            }
//        }
//        .animation(.easeInOut, value: isCustomer || isRestaurant)
    }
}


#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(RestaurantViewModel())
}
