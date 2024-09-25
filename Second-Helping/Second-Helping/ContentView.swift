//
//  ContentView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isCustomer = false
    @State private var isRestaurant = false
    
    var body: some View {
        VStack {
            if isCustomer {
                CustomerView(isLoggedIn: $isCustomer)
                    .transition(.slide)
            } else if isRestaurant {
                RestaurantView(isLoggedIn: $isRestaurant)
                    .transition(.slide)
            } else {
                LoginView(isCustomer: $isCustomer, isRestaurant: $isRestaurant)
                    .transition(.slide)
            }
        }
        .animation(.easeInOut, value: isCustomer || isRestaurant)
    }
}


#Preview {
    ContentView()
}
