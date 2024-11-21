//
//  SearchView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}

func distanceInMiles(userLat: Double, userLong: Double, restLat: Double, restLong: Double) -> Double {
    let startLocation = CLLocation(latitude: userLat, longitude: userLong)
    let endLocation = CLLocation(latitude: restLat, longitude: restLong)
    
    // Distance in meters
    let distanceInMeters = startLocation.distance(from: endLocation)
    
    // Conversion
    let distanceInMiles = distanceInMeters / 1609.34
    let formattedDistance = (distanceInMiles * 10).rounded() / 10
    
    return formattedDistance
}

func distanceTo(userLong: Double?, userLat: Double?, restLat: Double, restLong: Double) -> Double {
    if let hasUserLong = userLong, let hasUserLat = userLat {
        return distanceInMiles(userLat: hasUserLat, userLong: hasUserLong, restLat: restLat, restLong: restLong)
    } else {
        return 0.0
    }
}

extension Color {
    static let customGreen = Color(hex: "#4f7942")
    static let customGray = Color(hex: "#f2f2f2")
}

struct SearchView: View {
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
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
        ScrollView {
            
            VStack {
                Text("Browse food options")
                    .font(.custom("StudyClash", size: 40))
                    .foregroundColor(Color.customGreen)
                
//                if let location = locationManager.location {
//                    Text("Successfully found location")
//                        .onAppear {
//                            userLat = location.latitude
//                            userLong = location.longitude
//                        }
//                    Text("Longitude: \(String(describing: userLong))")
//                    Text("Latitude: \(String(describing: userLat))")
//                }
//                
//                LocationButton {
//                    locationManager.requestLocation()
//                }
//                .frame(height: 44)
//                .padding()
                
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
                    Text("Showing food options for \"" + searchBar + "\"...")
                        .font(.custom("StudyClash", size: 18))
                        .foregroundColor(.customGreen)
                        .padding()
                } else {
                    Text("Showing all food options...")
                        .font(.custom("StudyClash", size: 18))
                        .foregroundColor(.customGreen)
                        .padding()
                }
                
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
                    NavigationLink(destination: StatsView()) {
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
                            ForEach(restaurantViewModel.restaurants.filter
                                { searchBar.isEmpty ||
                                $0.name.localizedCaseInsensitiveContains(searchBar) ||
                                $0.meals.contains { $0.bagType.localizedCaseInsensitiveContains(searchBar) }}) { restaurant in
                                    
                                let lunchMeals = restaurant.meals.filter { $0.type == "Lunch" && searchBar.isEmpty ||
                                    $0.type == "Lunch" && $0.bagType.localizedCaseInsensitiveContains(searchBar) ||
                                    $0.type == "Lunch" && restaurant.name.localizedCaseInsensitiveContains(searchBar)}
                                
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
                    NavigationLink(destination: StatsView()) {
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
                            ForEach(restaurantViewModel.restaurants.filter
                                { searchBar.isEmpty ||
                                $0.name.localizedCaseInsensitiveContains(searchBar) ||
                                $0.meals.contains { $0.bagType.localizedCaseInsensitiveContains(searchBar) }}) { restaurant in
                                    
                                let dinnerMeals = restaurant.meals.filter { $0.type == "Dinner" && searchBar.isEmpty ||
                                    $0.type == "Dinner" && $0.bagType.localizedCaseInsensitiveContains(searchBar) ||
                                    $0.type == "Dinner" && restaurant.name.localizedCaseInsensitiveContains(searchBar)}
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
            }
            .padding(.top)
            .onAppear {
                Task {
                    await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
                }
            }
            .sheet(isPresented: $showMealDetail) {
                if let meal = selectedMeal {
                    MealDetailSheet(meal: meal)
                }
            }
        }
        .background(.white)
    }
}

#Preview {
    SearchView().environmentObject(RestaurantViewModel())
}









