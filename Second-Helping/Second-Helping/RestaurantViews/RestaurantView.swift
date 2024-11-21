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
    @Binding var isRestaurant: Bool
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Second Helping")
                    .font(.custom("StudyClash", size: 28))
                    .underline()
                    .foregroundColor(Color.customGreen)
                    .padding([.horizontal, .top])
                Spacer()
                Button(action: {
                    restaurantViewModel.currentRestaurant = nil
                    isLoggedIn = false
                    isRestaurant = false
                }) {
                    Text("Logout")
                        .font(.custom("StudyClash", size: 24))
                        .foregroundColor(Color.red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                        )
                }
                .padding([.horizontal, .top])
            }
            .padding(.bottom, 12)
            .background(Color.customGreen.opacity(0.3))
                
            ZStack(alignment: .top) {
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
                    PastOrdersView()
                        .tabItem() {
                            Image(systemName: "clock")
                            Text("Past Orders")
                        }
                }
                
                SquigglyDividerTopBG()
                    .fill(Color.white)
                    .frame(height: 10)
                SquigglyDividerTopBG()
                    .fill(Color.customGreen.opacity(0.3))
                    .frame(height: 10)
                SquigglyDivider()
                    .stroke(Color.customGreen, lineWidth: 3)
                    .frame(height: 10)
            }
            .edgesIgnoringSafeArea(.top)
        }
        
    }
}


#Preview {
    RestaurantView(isLoggedIn: .constant(true), isRestaurant: .constant(true)).environmentObject(RestaurantViewModel())
}
