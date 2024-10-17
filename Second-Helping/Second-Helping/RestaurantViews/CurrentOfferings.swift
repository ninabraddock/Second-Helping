//
//  CurrentOfferings.swift
//  Second-Helping
//
//  Created by Charlie Corriero  on 10/17/24.
//


import SwiftUI
import FirebaseAuth

struct CurrentOfferings: View {
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
    var currentRestaurant: Restaurant? {
        return restaurantViewModel.restaurants.first { $0.name == "Waterworks" }// TODO: Change this to grab the restaurants name from the login
    }
    
    var body: some View {
        let customGreen = Color(hex: "#4f7942")
        VStack {
            Text("Waterwork's Current Offerings") //TODO: Change this to show the name of the currently logged in restaurant
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(customGreen)
                .padding([.top], 40)
            
            Spacer()
            
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
                    
                    
                    if let restaurant = currentRestaurant {
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
                    if let restaurant = currentRestaurant{
                        let lunchMeals = restaurant.meals.filter { $0.type == "Lunch" }
                        ForEach(lunchMeals) { meal in
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
            Spacer()
        }
        .onAppear {
            Task {
                await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
            }
        }
    }
}



#Preview {
    CurrentOfferings().environmentObject(RestaurantViewModel())
}









