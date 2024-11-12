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
    
    // Show intro only when the app is first launched
    @State private var showIntro = true
    @State private var introOpacity = 1.0
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var loadingState: LoadingState
    
    var body: some View {
        ZStack {
            Group {
                if isLoggedIn {
                    if isCustomer {
                        CustomerView(isLoggedIn: $isLoggedIn, isCustomer: $isCustomer)
                            .transition(.slide)
                    } else {
                        // isRestaurant = true
                        RestaurantView(isLoggedIn: $isLoggedIn, isRestaurant: $isRestaurant)
                            .transition(.slide)
                    }
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, isCustomer: $isCustomer, isRestaurant: $isRestaurant)
                        .transition(.slide)
                }
            }
            if loadingState.isLoading {
                LoadingView()
                    .edgesIgnoringSafeArea(.all)
            }
            if showIntro {
                IntroView()
                    .opacity(introOpacity)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                            withAnimation(.easeInOut(duration: 0.5)) {  // Fade-out duration
                                introOpacity = 0
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
                            withAnimation {
                                showIntro = false
                            }
                        }
                    }
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
