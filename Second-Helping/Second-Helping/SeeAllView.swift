//
//  SeeAllView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 11/21/24.
//

import SwiftUI

struct SeeAllView: View {
    var restaurants: [Restaurant]
    var isLunch: Bool
    var isRestaurant: Bool
    @Binding var searchBar: String
    
    // State for displaying the detail view
    @State private var selectedMeal: Meal?
    @State private var selectedRestaurant: Restaurant?
    @State private var showMealDetail = false
    
    private let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        ScrollView {
            VStack {
                Text(isLunch ? "Lunch Options" : "Dinner Options")
                    .font(.custom("StudyClash", size: 30))
                    .foregroundColor(Color.customGreen)
                
                TextField("Search restaurants/meal types...", text: $searchBar)
                    .font(.custom("StudyClash", size: 20))
                    .padding(10)
                    .background(Color.customGray)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.customGreen, lineWidth: 2)
                    )
                    .padding(.horizontal, 15)
                
                if searchBar.count >= 1 {
                    Text(isLunch ?  "Showing lunch options for \"" + searchBar + "\"..." :
                                    "Showing dinner options for \"" + searchBar + "\"...")
                        .font(.custom("StudyClash", size: 18))
                        .foregroundColor(.customGreen)
                        .padding()
                } else {
                    Text(isLunch ? "Showing all lunch options..." : "Showing all dinner options...")
                        .font(.custom("StudyClash", size: 18))
                        .foregroundColor(.customGreen)
                        .padding()
                }
                
                LazyVGrid(columns: columns, spacing: 16) {
                    if !(filteredRestaurants.contains { !filteredMeals(for: $0).isEmpty }) {
                        EmptyProductCard()
                            .frame(width: 185, height: 160)
                            .foregroundStyle(.black)
                    } else {
                        ForEach(filteredRestaurants) { restaurant in
                            ForEach(filteredMeals(for: restaurant)) { meal in
                                Button {
                                    if !isRestaurant {
                                        // Set the selected meal, restaurant and show the detail sheet
                                        selectedMeal = meal
                                        selectedRestaurant = restaurant
                                        showMealDetail = true
                                    }
                                } label: {
                                    ProductCard(
                                        image: Image("waterworks"), // replace with image
                                        quantity: Int(meal.quantity),
                                        name: restaurant.name,
                                        bagType: meal.bagType,
                                        rangePickUpTime: "\(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)",
                                        ranking: restaurant.meanRating,
                                        distance: distanceTo(userLong: nil, userLat: nil, restLat: restaurant.latitude, restLong: restaurant.longitude),
                                        price: meal.price,
                                        btnHandler: nil
                                    )
                                }
                                .frame(width: 175, height: 150)
                                .foregroundStyle(.black)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .sheet(isPresented: $showMealDetail) {
            if let meal = selectedMeal {
                MealDetailSheet(meal: meal)
            }
        }
    }

    private var filteredRestaurants: [Restaurant] {
        restaurants.filter { searchBar.isEmpty ||
            $0.name.localizedCaseInsensitiveContains(searchBar) ||
            $0.meals.contains { $0.bagType.localizedCaseInsensitiveContains(searchBar) }
        }
    }
    
    private func filteredMeals(for restaurant: Restaurant) -> [Meal] {
        restaurant.meals.filter { meal in
            meal.type == (isLunch ? "Lunch" : "Dinner") &&
            (searchBar.isEmpty || meal.bagType.localizedCaseInsensitiveContains(searchBar) || restaurant.name.localizedCaseInsensitiveContains(searchBar))
        }
    }
}

#Preview {
    SeeAllView(restaurants: [], isLunch: true, isRestaurant: false, searchBar: .constant(""))
}
