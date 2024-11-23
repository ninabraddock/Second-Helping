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
    @EnvironmentObject var loadingState: LoadingState
    @State private var searchBar = ""
    
    var body: some View {
        if let currentRestaurant = restaurantViewModel.currentRestaurant {
            NavigationView {
                ScrollView {
                    VStack {
                        
                        
                        // Section for Lunch
                        HStack{
                            Text("Lunch")
                                .font(.custom("StudyClash", size: 24))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.customGreen.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.customGreen, lineWidth: 2)
                                        )
                                )
                                .foregroundColor(Color.customGreen)
                                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 4)
                                .underline()
                            Spacer()
                            NavigationLink(destination: SeeAllView(
                                restaurants: [currentRestaurant],
                                isLunch: true,
                                isRestaurant: true,
                                searchBar: $searchBar
                            )) {
                                Text("See All")
                                    .font(.custom("StudyClash", size: 18))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .padding(.horizontal, 15)
                        ZStack {
                            Color(Color.customGreen)
                                .opacity(0.3)
                                .cornerRadius(10)
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    Spacer().padding(.leading, 1)
                                    let lunchMeals = currentRestaurant.meals.filter { $0.type == "Lunch" }
                                    if lunchMeals.isEmpty {
                                        EmptyProductCard()
                                            .frame(width: 185, height: 160)
                                            .foregroundStyle(.black)
                                    } else {
                                        ForEach(lunchMeals) { meal in
                                            ProductCard(
                                                image: Image("waterworks"), // replace with image
                                                quantity: Int(meal.quantity),
                                                name: currentRestaurant.name,
                                                bagType: meal.bagType,
                                                rangePickUpTime: "\(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)",
                                                ranking: currentRestaurant.meanRating,
                                                distance: 0.0, // Setting to 0 becuase this is the current restaurant, might change later
                                                price: meal.price,
                                                btnHandler: nil
                                            )
                                            .frame(width: 185, height: 160)
                                            .foregroundStyle(.black)
                                        }
                                    }
                                    Spacer().padding(.trailing, 1)
                                }
                            }
                            .frame(height: 200)
                            .scrollIndicators(.visible)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.customGreen, lineWidth: 2)
                        )
                        .padding(.horizontal, 15)
                        
                        
                        // Divider
                        Rectangle()
                            .fill(.black)
                            .frame(height: 1)
                            .padding(.top)
                        
                        // Section for Dinner
                        HStack{
                            Text("Dinner")
                                .font(.custom("StudyClash", size: 24))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.customGreen.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.customGreen, lineWidth: 2)
                                        )
                                )
                                .foregroundColor(Color.customGreen)
                                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 4)
                                .underline()
                            Spacer()
                            NavigationLink(destination: SeeAllView(
                                restaurants: [currentRestaurant],
                                isLunch: false,
                                isRestaurant: true,
                                searchBar: $searchBar
                            )) {
                                Text("See All")
                                    .font(.custom("StudyClash", size: 18))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.top)
                        
                        ZStack {
                            Color(Color.customGreen)
                                .opacity(0.3)
                                .cornerRadius(10)
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    Spacer().padding(.leading, 1)
                                    let dinnerMeals = currentRestaurant.meals.filter { $0.type == "Dinner" }
                                    if dinnerMeals.isEmpty {
                                        EmptyProductCard()
                                            .frame(width: 185, height: 160)
                                            .foregroundStyle(.black)
                                    } else {
                                        ForEach(dinnerMeals) { meal in
                                            ProductCard(
                                                image: Image("waterworks"), // replace with image
                                                quantity: Int(meal.quantity),
                                                name: currentRestaurant.name,
                                                bagType: meal.bagType,
                                                rangePickUpTime: "\(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)",
                                                ranking: currentRestaurant.meanRating,
                                                distance: 0.0, // Setting to 0 becuase this is the current restaurant, might change later
                                                price: meal.price,
                                                btnHandler: nil
                                            )
                                            .frame(width: 185, height: 160)
                                            .foregroundStyle(.black)
                                        }
                                    }
                                    Spacer().padding(.trailing, 1)
                                }
                            }
                            .frame(height: 200)
                            .scrollIndicators(.visible)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.customGreen, lineWidth: 2)
                        )
                        .padding(.horizontal, 15)
                        
                        Spacer()
                    }
                    .onAppear {
                        Task {
                            await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
                        }
                    }
                }
                .refreshable {
                    Task {
                        loadingState.isLoading = true
                        await restaurantViewModel.fetchRestaurants()
                        loadingState.isLoading = false
                    }
                }
            }
        }
    }
}



#Preview {
    CurrentOfferings().environmentObject(RestaurantViewModel()).environmentObject(LoadingState())
}









