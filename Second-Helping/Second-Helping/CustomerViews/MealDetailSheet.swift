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
    @State private var quantity = 0
    @State private var isFavorite = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    toggleFavorite()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .pink : .gray) // Light pink when liked
                        .font(.system(size: 24))
                }
                .padding(.top, 10)
                .padding(.trailing, 20)
            }
            
            Text("Meal Type: \(meal.type)")
            Text("Bag Type: \(meal.bagType)")
            Text("Price: \(meal.price, specifier: "%.2f")")
            Text("Quantity: \(meal.quantity)")
            Text("Pick-Up Time: \(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)")
        }
        .padding()
        .onAppear {
                    Task {
                        await restaurantViewModel.fetchRestaurants()
                        await authViewModel.fetchUsers()
                        checkIfFavorite()
                    }
                }
        .presentationDetents([.medium, .large]) // Control the height of the sheet
        
        // stepper for picking quantity
        Stepper("Quantity: \(quantity)", value: $quantity, in: 1...meal.quantity)
        
        
        Button(action: {
            if let currentUser = authViewModel.currentUser {
                print(currentUser.fullName)
                restaurantViewModel.addToActiveOrders(meal: meal, restaurantArray: restaurantViewModel.restaurants, quantity: quantity, mealOrderUser: currentUser.fullName
                )
            } else {
                print("No current user available")
            }
        }) {
            Text("Order")
        }
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
    MealDetailSheet(meal: Meal(bagType: "Mystery Bag", price: 5.00, quantity: 5, rangePickUpTime: PickUpTime(start:"9:00 PM", end:"10:30 PM"), type: "Dinner", restaurantFrom: "Placeholder restaurant", mealOrderUser: "Placeholder User"))
}
