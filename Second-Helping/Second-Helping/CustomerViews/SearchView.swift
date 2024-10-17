//
//  SearchView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
    var body: some View {
        let customGreen = Color(hex: "#4f7942")
        VStack {
            Text("Browse food options")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(customGreen)
            // Section for Dinner
            HStack{
                Text("Dinner")
                    .underline()
                    .font(.title2)
                    .padding()
                Spacer()
                NavigationLink(destination: StatsView()) {
                    Text("See All")
                        .padding()
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(restaurantViewModel.restaurants) { restaurant in
                        let dinnerMeals = restaurant.meals.filter { $0.type == "Dinner" }
                        ForEach(dinnerMeals) { meal in
                            ProductCard(
                                image: Image("waterworks"), // replace with image
                                quantity: Int(meal.quantity),
                                name: restaurant.name,
                                bagType: meal.bagType,
                                rangePickUpTime: "\(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)",
                                ranking: restaurant.meanRating,
                                distance: 0.3, // replace with distance calculation
                                price: meal.price,
                                btnHandler: nil
                            )
                            
                        }
                    }
                }
            }

            // Section for Lunch
            HStack{
                Text("Lunch")
                    .underline()
                    .font(.title2)
                    .padding()
                Spacer()
                NavigationLink(destination: StatsView()) {
                    Text("See All")
                        .padding()
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(restaurantViewModel.restaurants) { restaurant in
                        let dinnerMeals = restaurant.meals.filter { $0.type == "Lunch" }
                        ForEach(dinnerMeals) { meal in
                            ProductCard(
                                image: Image("waterworks"), // replace with image
                                quantity: Int(meal.quantity),
                                name: restaurant.name,
                                bagType: meal.bagType,
                                rangePickUpTime: "\(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)",
                                ranking: restaurant.meanRating,
                                distance: 0.3, // replace with distance calculation
                                price: meal.price,
                                btnHandler: nil
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
            }
        }
    }
}

#Preview {
    SearchView()
}









