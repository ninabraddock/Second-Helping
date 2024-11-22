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

    
    
    
    var body: some View {
        VStack(spacing: 20) {
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
}

#Preview {
    MealDetailSheet(meal: Meal(bagType: "Mystery Bag", price: 5.00, quantity: 5, rangePickUpTime: PickUpTime(start:"9:00 PM", end:"10:30 PM"), type: "Dinner", restaurantFrom: "Placeholder restaurant", mealOrderUser: "Placeholder User"))
}
