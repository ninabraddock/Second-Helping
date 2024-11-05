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
    
    var body: some View {
        let customGreen = Color(hex: "#4f7942")
        VStack {
            Text("Browse food options")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(customGreen)
            
            if let location = locationManager.location {
                Text("Successfully found location")
                    .onAppear {
                        userLat = location.latitude
                        userLong = location.longitude
                    }
                Text("Longitude: \(String(describing: userLong))")
                Text("Latitude: \(String(describing: userLat))")
            }
            
            LocationButton {
                locationManager.requestLocation()
            }
            .frame(height: 44)
            .padding()
            
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
                            .foregroundStyle(.black)
                            
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
                                    distance: 0.3, // replace with distance calculation
                                    price: meal.price,
                                    btnHandler: nil
                                )
                            }
                            .foregroundStyle(.black)
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
        .sheet(isPresented: $showMealDetail) {
            if let meal = selectedMeal {
                MealDetailSheet(meal: meal)
            }
        }
    }
}

#Preview {
    SearchView().environmentObject(RestaurantViewModel())
}









