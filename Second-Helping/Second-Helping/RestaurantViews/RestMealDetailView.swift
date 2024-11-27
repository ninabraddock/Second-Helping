//
//  RestMealDetailView.swift
//  Second-Helping
//
//  Created by user266699 on 11/27/24.
//

import SwiftUI

struct RestMealDetailView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var restaurantViewModel: RestaurantViewModel
    let meal: Meal
    @State private var enteredQuantity = ""
    @State private var newQuantity = 0
    @State private var changedQuantity = false

    var body: some View {
        VStack(spacing: 15) {
            
            Text("Meal Details")
                .font(.custom("StudyClash", size: 24))
                .foregroundColor(Color.customGreen)
                .underline()
                .padding(.horizontal)

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
            
            // Quantity Section
            Section(header:
                Text("Change Quantity")
                    .font(.custom("StudyClash", size: 18))
            ) {
                TextField("Enter Quantity", text: $enteredQuantity)
                    .font(.custom("StudyClash", size: 18))
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                    .onChange(of: enteredQuantity) {
                        // Update newQuantity only if enteredQuantity is a valid number
                        if let quantity = Int(enteredQuantity), quantity >= 0 {
                            newQuantity = quantity
                        } else {
                            newQuantity = 0
                        }
                    }
            }
            
            Button(action: {
                if let currentRestaurant = restaurantViewModel.currentRestaurant {
                    print(currentRestaurant.name)
                    restaurantViewModel.changeMealQuantity(meal: meal, restaurantArray: restaurantViewModel.restaurants, quantity: newQuantity)
                    changedQuantity = true
                } else {
                    print("No current user available")
                }
            }) {
                Text("Change Quantity")
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
            
            if changedQuantity {
                Text("You have successfully changed the quantity")
                    .font(.custom("StudyClash", size: 16))
                    .foregroundColor(Color.customGreen)
                    .padding(.horizontal)
                    .padding(.bottom)
            } else {
                Text("")
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
                    }
                }
        .border(Color.customGreen, width: 6)
        .presentationDetents([.medium, .large]) // Control the height of the sheet
        
    }
}

#Preview {
    MealDetailSheet(meal: Meal(bagType: "Mystery Bag", originalPrice: 5.00, reducedPrice: 3.00, quantity: 5, rangePickUpTime: PickUpTime(start:"9:00 PM", end:"10:30 PM"), type: "Dinner", restaurantFrom: "Placeholder restaurant", mealOrderUser: "Placeholder User"))
}
