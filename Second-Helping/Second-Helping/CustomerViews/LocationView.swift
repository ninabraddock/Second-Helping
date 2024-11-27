//
//  LocationView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//


import SwiftUI
import MapKit
import FirebaseFirestore

struct LocationView: View {
    let border_color = Color("border_map_pin")
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // set window
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
    // to catch duplicate addresses
    @State private var visitedAddresses: Set<String> = []
    @State private var selectedRestaurant: Restaurant?

    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, annotationItems: restaurantViewModel.restaurants) { location in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                ) {
                    Button(action: {
                        selectedRestaurant = location
                    }) {
                        ZStack {
                            // border
                            Image(systemName: "drop.fill")
                                .resizable()
                                .frame(width: 23, height: 31)
                                .rotationEffect(.degrees(180))
                                .foregroundColor(border_color)
                            
                            // frame/main part
                            Image(systemName: "drop.fill")
                                .resizable()
                                .frame(width: 22, height: 30)
                                .rotationEffect(.degrees(180))
                                .foregroundColor(.red)
                            
                            // inner circle
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .offset(y: -4)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                Task {
                    await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
                }
            }
        }
        .sheet(item: $selectedRestaurant) { restaurant in
            RestaurantDetailSheetView(restaurant: restaurant)
                .presentationDragIndicator(.visible)
        }
    }
}


struct RestaurantDetailSheetView: View {
    var restaurant: Restaurant
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    
    // State for displaying the detail view
    @State private var selectedMeal: Meal?
    @State private var selectedRestaurant: Restaurant?
    @State private var showMealDetail = false
    
    
    var body: some View {
        VStack {
            Text("Current Offerings at \(restaurant.name)")
                .font(.custom("StudyClash", size: 40))
                .foregroundColor(Color.customGreen)
                .padding(.top, 40)
                .multilineTextAlignment(.center)
            
            // Divider
            Rectangle()
                .fill(Color.customGreen)
                .frame(height: 1)
                .padding(.horizontal, 15)
            
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
            }
            .padding(.horizontal, 15)
            
            ZStack {
                Color(Color.customGreen)
                    .opacity(0.3)
                    .cornerRadius(10)
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        Spacer().padding(.leading, 1)
                        let lunchMeals = restaurant.meals.filter { $0.type == "Lunch" }
                        if lunchMeals.isEmpty {
                            EmptyProductCard()
                                .frame(width: 185, height: 160)
                                .foregroundStyle(.black)
                        } else {
                            ForEach(lunchMeals) { meal in
                                Button {
                                    // Set the selected meal, restaurant and show the detail sheet
                                    selectedMeal = meal
                                    selectedRestaurant = restaurant
                                    showMealDetail = true
                                } label: {
                                    ProductCard(
                                        id: meal.id,
                                        image: Image("waterworks"), // replace with image
                                        quantity: Int(meal.quantity),
                                        name: restaurant.name,
                                        bagType: meal.bagType,
                                        rangePickUpTime: "\(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)",
                                        ranking: restaurant.meanRating,
                                        distance: 0.0, // Setting to 0 because this is the current restaurant
                                        reducedPrice: meal.reducedPrice,
                                        btnHandler: nil
                                    )
                                }
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
                .fill(Color.customGreen)
                .frame(height: 1)
                .padding(.top)
                .padding(.horizontal, 15)
            
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
                        let dinnerMeals = restaurant.meals.filter { $0.type == "Dinner" }
                        if dinnerMeals.isEmpty {
                            EmptyProductCard()
                                .frame(width: 185, height: 160)
                                .foregroundStyle(.black)
                        } else {
                            ForEach(dinnerMeals) { meal in
                                Button {
                                    // Set the selected meal, restaurant and show the detail sheet
                                    selectedMeal = meal
                                    selectedRestaurant = restaurant
                                    showMealDetail = true
                                } label: {
                                    ProductCard(
                                        id: meal.id,
                                        image: Image("waterworks"), // replace with image
                                        quantity: Int(meal.quantity),
                                        name: restaurant.name,
                                        bagType: meal.bagType,
                                        rangePickUpTime: "\(meal.rangePickUpTime.start) - \(meal.rangePickUpTime.end)",
                                        ranking: restaurant.meanRating,
                                        distance: 0.0, // Setting to 0 becuase this is the current restaurant, might change later
                                        reducedPrice: meal.reducedPrice,
                                        btnHandler: nil
                                    )
                                }
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
        .background(Color.white)
        .onAppear {
            Task {
                await authViewModel.fetchUsers()
                await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
            }
        }
        .sheet(isPresented: $showMealDetail) {
            if let meal = selectedMeal {
                MealDetailSheet(meal: meal)
            }
        }
        .onChange(of: showMealDetail) {
            Task {
                await authViewModel.fetchUsers()
                await restaurantViewModel.fetchRestaurants()
            }
        }
    }
}



#Preview {
    LocationView().environmentObject(RestaurantViewModel())
}
