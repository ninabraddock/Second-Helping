//
//  FavoritesView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var loadingState: LoadingState
    @StateObject var locationManager = LocationManager()
    @State var userLat: Double?
    @State var userLong: Double?
    @State var distance: Double?
    
    // State for displaying the detail view
    @State private var selectedMeal: Meal?
    @State private var selectedRestaurant: Restaurant?
    @State private var showMealDetail = false
    
    @State private var searchBar = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Favorite Meals!")
                        .font(.custom("StudyClash", size: 40))
                        .foregroundColor(Color.pink)
                        .padding(.top, 20)
                    
                    TextField("Search restaurants/meal types...", text: $searchBar)
                        .font(.custom("StudyClash", size: 20))
                        .padding(10)
                        .background(Color.customGray)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.pink, lineWidth: 2)
                        )
                        .padding(.horizontal, 15)
                    
                    if searchBar.count >= 1 {
                        Text("Showing food options for \"" + searchBar + "\"...")
                            .font(.custom("StudyClash", size: 18))
                            .foregroundColor(.pink)
                            .padding()
                    } else {
                        Text("Showing all food options...")
                            .font(.custom("StudyClash", size: 18))
                            .foregroundColor(.pink)
                            .padding()
                    }
                    
                    
                    // Divider
                    Rectangle()
                        .fill(Color.pink)
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
                                    .fill(Color.pink.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.pink, lineWidth: 2)
                                    )
                            )
                            .foregroundColor(Color.pink)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 4)
                            .underline()
                        Spacer()
                        NavigationLink(destination: SeeAllView(
                            restaurants: restaurantViewModel.restaurants,
                            isLunch: true,
                            isRestaurant: false,
                            searchBar: $searchBar
                        )) {
                            Text("See All")
                                .font(.custom("StudyClash", size: 18))
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    ZStack {
                        Color(Color.pink)
                            .opacity(0.3)
                            .cornerRadius(10)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                Spacer().padding(.leading, 1)
                                if let curUser = authViewModel.currentUser {
                                    let filteredRestaurants = restaurantViewModel.restaurants.filter { restaurant in
                                        (searchBar.isEmpty ||
                                        restaurant.name.localizedCaseInsensitiveContains(searchBar) ||
                                        restaurant.meals.contains { $0.bagType.localizedCaseInsensitiveContains(searchBar) }) &&
                                        restaurant.meals.contains { $0.type == "Lunch" } &&
                                        restaurant.meals.contains { meal in
                                            if let mealId = meal.id?.uuidString {
                                                return curUser.favoriteMeals.contains(mealId) && meal.type == "Lunch"
                                            }
                                            return false
                                        }
                                    }
                                    
                                    if filteredRestaurants.isEmpty {
                                        EmptyProductCard()
                                            .frame(width: 185, height: 160)
                                            .foregroundStyle(.black)
                                    } else {
                                        ForEach(filteredRestaurants) { restaurant in
                                            let lunchMeals = restaurant.meals.filter { meal in
                                                guard let mealId = meal.id?.uuidString else {
                                                    return false
                                                }
                                                return meal.type == "Lunch" &&
                                                       (searchBar.isEmpty ||
                                                        meal.bagType.localizedCaseInsensitiveContains(searchBar) ||
                                                        restaurant.name.localizedCaseInsensitiveContains(searchBar)) &&
                                                        curUser.favoriteMeals.contains(mealId)
                                            }
                                            
                                            let restLat = restaurant.latitude
                                            let restLong = restaurant.longitude
                                            var distanceToRest = distanceTo(userLong: userLong, userLat: userLat, restLat: restLat, restLong: restLong)
                                            
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
                                                        distance: distanceToRest,
                                                        price: meal.price,
                                                        btnHandler: nil
                                                    )
                                                }
                                                .frame(width: 185, height: 160)
                                                .foregroundStyle(.black)
                                                
                                                
                                            }
                                        }
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
                            .stroke(Color.pink, lineWidth: 2)
                    )
                    .padding(.horizontal, 15)
                    
                    
                    // Divider
                    Rectangle()
                        .fill(Color.pink)
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
                                    .fill(Color.pink.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.pink, lineWidth: 2)
                                    )
                            )
                            .foregroundColor(Color.pink)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 4)
                            .underline()
                        Spacer()
                        NavigationLink(destination: SeeAllView(
                            restaurants: restaurantViewModel.restaurants,
                            isLunch: false,
                            isRestaurant: false,
                            searchBar: $searchBar
                        )) {
                            Text("See All")
                                .font(.custom("StudyClash", size: 18))
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    ZStack {
                        Color(Color.pink)
                            .opacity(0.3)
                            .cornerRadius(10)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                Spacer().padding(.leading, 1)
                                if let curUser = authViewModel.currentUser {
                                    let filteredRestaurants = restaurantViewModel.restaurants.filter { restaurant in
                                        (searchBar.isEmpty ||
                                        restaurant.name.localizedCaseInsensitiveContains(searchBar) ||
                                        restaurant.meals.contains { $0.bagType.localizedCaseInsensitiveContains(searchBar) }) &&
                                        restaurant.meals.contains { $0.type == "Dinner" } &&
                                        restaurant.meals.contains { meal in
                                            if let mealId = meal.id?.uuidString {
                                                return curUser.favoriteMeals.contains(mealId) && meal.type == "Dinner"
                                            }
                                            return false
                                        }
                                    }
                                    if filteredRestaurants.isEmpty {
                                        EmptyProductCard()
                                            .frame(width: 185, height: 160)
                                            .foregroundStyle(.black)
                                    } else {
                                        ForEach(filteredRestaurants) { restaurant in
                                            let dinnerMeals = restaurant.meals.filter { meal in
                                                guard let mealId = meal.id?.uuidString else {
                                                    return false
                                                }
                                                return meal.type == "Dinner" &&
                                                       (searchBar.isEmpty ||
                                                        meal.bagType.localizedCaseInsensitiveContains(searchBar) ||
                                                        restaurant.name.localizedCaseInsensitiveContains(searchBar)) &&
                                                        curUser.favoriteMeals.contains(mealId)
                                            }
                                            
                                            let restLat = restaurant.latitude
                                            let restLong = restaurant.longitude
                                            var distanceToRest = distanceTo(userLong: userLong, userLat: userLat, restLat: restLat, restLong: restLong)
                                            
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
                                                        distance: distanceToRest,
                                                        price: meal.price,
                                                        btnHandler: nil
                                                    )
                                                }
                                                .frame(width: 185, height: 160)
                                                .foregroundStyle(.black)
                                            }
                                        }
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
                            .stroke(Color.pink, lineWidth: 2)
                    )
                    .padding(.horizontal, 15)
                }
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
            .refreshable {
                Task {
                    loadingState.isLoading = true
                    await restaurantViewModel.fetchRestaurants()
                    loadingState.isLoading = false
                }
            }
            .background(.white)
        }
    }
}

#Preview {
    FavoritesView()
}
