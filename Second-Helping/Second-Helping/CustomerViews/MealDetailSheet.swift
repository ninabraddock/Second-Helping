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
        

        Button(action: {
            // havent tested them yet
            authViewModel.completeOrderForUser(meal: meal)
            restaurantViewModel.completeOrderForRestaurant(meal: meal, restaurantArray: restaurantViewModel.restaurants)
        }) {
            Text("Complete Order")
        }
    }
}

#Preview {
    MealDetailSheet(meal: Meal(bagType: "Mystery Bag", price: 5.00, quantity: 5, rangePickUpTime: PickUpTime(start:"9:00 PM", end:"10:30 PM"), type: "Dinner", restaurantFrom: "Placeholder restaurant"))
}
