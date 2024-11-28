//
//  MealDetailSheet.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 11/5/24.
//

import SwiftUI

struct MealDetailSheet: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var restaurantViewModel: RestaurantViewModel
    let meal: Meal
    @State private var quantity = 1
    @State private var isFavorite = false
    @State private var haveOrdered = false

    var body: some View {
        VStack(spacing: 15) {
            // Show Meal Details and heart on the same line
            ZStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .pink : .gray)
                            .font(.system(size: 24))
                    }
                    .padding(.trailing)
                    .padding(.top, 40)
                }
                
                Text("Meal Details")
                    .font(.custom("StudyClash", size: 24))
                    .foregroundColor(Color.customGreen)
                    .underline()
                    .padding(.horizontal)
                    .padding(.top, 40)
            }


            Text("Meal Type: \(meal.type)")
                .font(.custom("StudyClash", size: 20))
                .foregroundColor(Color.customGreen)
                .padding(.horizontal)
            
            Text("Bag Type: \(meal.bagType)")
                .font(.custom("StudyClash", size: 20))
                .foregroundColor(Color.customGreen)
                .padding(.horizontal)
            
            Text("originalPrice: \(meal.originalPrice, specifier: "%.2f")")
                .font(.custom("StudyClash", size: 20))
                .foregroundColor(Color.customGreen)
                .padding(.horizontal)
            
            Text("reducedPrice: \(meal.reducedPrice, specifier: "%.2f")")
                .font(.custom("StudyClash", size: 20))
                .foregroundColor(Color.customGreen)
                .padding(.horizontal)
            
            Text("Quantity: \(meal.quantity)")
                .font(.custom("StudyClash", size: 20))
                .foregroundColor(Color.customGreen)
                .padding(.horizontal)
            
            Text("Pick-Up Time: \(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)")
                .font(.custom("StudyClash", size: 20))
                .foregroundColor(Color.customGreen)
                .padding(.horizontal)
            
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...meal.quantity)
                .padding(10)
                .padding(.horizontal, 15)
                .font(.custom("StudyClash", size: 20))
                .background(Color.customGray)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.customGreen, lineWidth: 2)
                )
            
            Button(action: {
                if let currentUser = authViewModel.currentUser {
                    let orderID = UUID()
                    restaurantViewModel.addToActiveOrders(meal: meal, restaurantArray: restaurantViewModel.restaurants, quantity: quantity, mealOrderUser: currentUser.fullName, orderID: orderID)
                    authViewModel.completeOrderForUser(meal: meal, restaurantArray: restaurantViewModel.restaurants, quantity: quantity, orderID: orderID)
                    haveOrdered = true
                } else {
                    print("No current user available")
                }
            }) {
                Text("Place Order")
            }
            .font(.custom("StudyClash", size: 20))
            .foregroundColor(Color.customGreen)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.customGreen.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.customGreen, lineWidth: 2)
                    )
            )
            
            if haveOrdered {
                Text("You have successfully placed your order!")
                    .font(.custom("StudyClash", size: 16))
                    .foregroundColor(Color.customGreen)
                    .padding(.horizontal)
                    .padding(.bottom)
            } else {
                Text(" ")
                    .font(.custom("StudyClash", size: 16))
                    .foregroundColor(Color.customGreen)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .padding()
        .onAppear {
            Task {
                await restaurantViewModel.fetchRestaurants()
                await authViewModel.fetchUsers()
                checkIfFavorite()
            }
        }
        .border(Color.customGreen, width: 6)
        .presentationDetents([.medium, .large]) // Control the height of the sheet
        
        // stepper for picking quantity
        
    }
    
    
    private func toggleFavorite() {
        guard let currentUser = authViewModel.currentUser, let mealId = meal.id else {
            print("Meal ID is nil")
            return
        }
        
        let mealIdString = mealId.uuidString
        
        isFavorite.toggle()
        
        if isFavorite {
            authViewModel.addFavoriteMeal(mealId: mealIdString)
        } else {
            authViewModel.removeFavoriteMeal(mealId: mealIdString)
        }
    }

    
    private func checkIfFavorite() {
        guard let currentUser = authViewModel.currentUser, let mealId = meal.id else {
            return
        }
        
        let mealIdString = mealId.uuidString
        
        isFavorite = currentUser.favoriteMeals.contains(mealIdString)
    }
}

#Preview {
    MealDetailSheet(meal: Meal(bagType: "Mystery Bag", originalPrice: 5.00, reducedPrice: 3.00, quantity: 5, rangePickUpTime: PickUpTime(start:"9:00 PM", end:"10:30 PM"), type: "Dinner", restaurantFrom: "Placeholder restaurant", mealOrderUser: "Placeholder User"))
}
