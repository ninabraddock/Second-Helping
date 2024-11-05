//
//  ContentView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isCustomer: Bool
    @Binding var isRestaurant: Bool
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if isLoggedIn {
                if isCustomer {
                    CustomerView(isLoggedIn: $isLoggedIn, isCustomer: $isCustomer) .transition(.slide)
                } else {
                    RestaurantView(isLoggedIn: $isLoggedIn, isRestaurant: $isRestaurant) .transition(.slide)
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn, isCustomer: $isCustomer, isRestaurant: $isRestaurant) .transition(.slide)
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
    ContentView(isLoggedIn: .constant(false), isCustomer: .constant(true), isRestaurant: .constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(RestaurantViewModel())
}
