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
    @EnvironmentObject var loadingState: LoadingState
    
    var body: some View {
        ZStack {
            Group {
                if isLoggedIn {
                    if isCustomer {
                        CustomerView(isLoggedIn: $isLoggedIn, isCustomer: $isCustomer) .transition(.slide)
                    } else {
                        // isRestaurant = true
                        RestaurantView(isLoggedIn: $isLoggedIn, isRestaurant: $isRestaurant) .transition(.slide)
                    }
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, isCustomer: $isCustomer, isRestaurant: $isRestaurant) .transition(.slide)
                }
            }
            if loadingState.isLoading {
                LoadingView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


#Preview {
    ContentView(isLoggedIn: .constant(false), isCustomer: .constant(true), isRestaurant: .constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(RestaurantViewModel())
        .environmentObject(LoadingState())
}
