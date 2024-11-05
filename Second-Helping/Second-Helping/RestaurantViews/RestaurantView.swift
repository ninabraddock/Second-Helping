//
//  RestaurantView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct RestaurantView: View {
    // Setting this to false should cause the restaurant to "log out"
    @Binding var isLoggedIn: Bool
    
    let customGreen = Color(hex: "#4f7942")
    
    var body: some View {
        ZStack {
            // Background color
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        isLoggedIn = false
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(Color.red)
                    }
                    .padding()
                }
                
                // TODO: add more views and tabs as needed
                TabView {
                    CurrentOfferings()
                        .tabItem() {
                            Image(systemName: "magnifyingglass")
                            Text("Current Offerings")
                        }
                    
                    AddMeal()
                        .tabItem() {
                            Image(systemName: "star.fill")
                            Text("Add Meal")
                        }
                    ActiveOrders()
                        .tabItem() {
                            Image(systemName: "checklist")
                            Text("Active Orders")
                        }
                    PastOrders()
                        .tabItem() {
                            Image(systemName: "clock")
                            Text("Past Orders")
                        }
                }
                .onAppear() {
                    UITabBar.appearance().backgroundColor = .lightGray
                }
            }
        }
        
    }
}


#Preview {
    RestaurantView(isLoggedIn: .constant(true)).environmentObject(RestaurantViewModel())
}
