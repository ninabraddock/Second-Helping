//
//  RestaurantViewModel.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 10/15/24.
//

import Foundation
import FirebaseFirestore

@MainActor
class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var currentRestaurant: Restaurant?
    
    private let firestore = Firestore.firestore()
    
    init() {
        Task {
            await fetchRestaurants()
        }
    }
    
    // Fetch all restaurants
    func fetchRestaurants() async {
        print("FETCHING RESTAURANTS")
        do {
            let snapshot = try await firestore.collection("restaurants").getDocuments()
            self.restaurants = snapshot.documents.compactMap { document in
                // Attempt to decode the restaurant
                do {
                    var restaurant = try document.data(as: Restaurant.self)
                    restaurant.id = document.documentID // Set the document ID
                    print("Decoded restaurant: \(String(describing: restaurant))")
                    return restaurant
                } catch {
                    // Print the error details
                    print("Error decoding restaurant: \(error)")
                    return nil // Return nil if decoding fails
                }
//                print("RESTAURANT \(restaurant)")
//                restaurant?.id = document.documentID  // Set the document ID manually
//                return restaurant
            }
            // Keep our same current restaurant
            if let curRestaurant = currentRestaurant {
                if let id = curRestaurant.id {
                    await fetchRestaurant(withID: id)
                } else {
                    // We don't have an id for that restaurant, lets try to find a restaurant with that name
                    let restName = curRestaurant.name
                    for restaurant in restaurants {
                        if restaurant.name == restName {
                            currentRestaurant = restaurant
                        }
                    }
                    
                }
            }
            print("RESTAURANTS FETCHED")
        } catch {
            print("Debug: failed to fetch restaurants with error \(error.localizedDescription)")
        }
    }
    
    // Fetch a specific restaurant by ID
    func fetchRestaurant(withID id: String) async {
        do {
            let document = try await firestore.collection("restaurants").document(id).getDocument()
            var restaurant = try? document.data(as: Restaurant.self)
            restaurant?.id = document.documentID  // Set the document ID manually
            self.currentRestaurant = restaurant
        } catch {
            print("Debug: failed to fetch restaurant with error \(error.localizedDescription)")
        }
    }
    
    // Add a new restaurant
    func addRestaurant(_ restaurant: Restaurant) async throws -> Bool {
        do {
            await fetchRestaurants()
            for r in restaurants {
                if r.name == restaurant.name {
                    print("Restaurant name already in use")
                    return false
                }
            }
            // Generate a new document ID
            let documentRef = firestore.collection("restaurants").document()
            var restaurantWithID = restaurant
            restaurantWithID.id = documentRef.documentID  // Set the document ID before saving
            let encoder = try Firestore.Encoder().encode(restaurantWithID)
            try await documentRef.setData(encoder)
            await fetchRestaurants()
            return true
        } catch {
            print("Debug: failed to add restaurant with error \(error.localizedDescription)")
            return false
        }
    }
    
    // Update an existing restaurant
    func updateRestaurant(_ restaurant: Restaurant) async throws {
        guard let restaurantID = restaurant.id else { return }
        do {
            let encoder = try Firestore.Encoder().encode(restaurant)
            try await firestore.collection("restaurants").document(restaurantID).updateData(encoder)
            await fetchRestaurant(withID: restaurantID)
        } catch {
            print("Debug: failed to update restaurant with error \(error.localizedDescription)")
            throw error
        }
    }
    
    // Delete a restaurant
    func deleteRestaurant(withID id: String) async throws {
        do {
            try await firestore.collection("restaurants").document(id).delete()
            await fetchRestaurants()
        } catch {
            print("Debug: failed to delete restaurant with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchCurrentRestaurant(uid: String) async {
        do {
            let document = try await firestore.collection("restaurants").document(uid).getDocument()
            let restaurant = try document.data(as: Restaurant.self)
            self.currentRestaurant = restaurant
        } catch {
            print("Error fetching current restaurant: \(error.localizedDescription)")
        }
    }
    
    
    func addToActiveOrders(meal: Meal, restaurantArray: [Restaurant], quantity: Int, mealOrderUser: String) {
        // filter to find the restaurant that the meal belongs to and save that in a variable
        let filteredArray = restaurantArray.filter { $0.name == meal.restaurantFrom }
        var restaurantVar = filteredArray[0]
        
        // create new meal with new quantity
        var newMeal = meal
        var replaceMeal = meal
        
        // decrement the quantity
        newMeal.quantity -= quantity
        replaceMeal.quantity -= quantity
        
        // update meal order user
        //not working???
        newMeal.mealOrderUser = mealOrderUser
        print("TESTING ADDTOACTIVE ORDER MEALRODERUSER: \(mealOrderUser)")
        print("TESTING NEWMEAL.MEALORDERUSER: \(newMeal.mealOrderUser)")
        // if it was the last meal
        if replaceMeal.quantity == 0 {
            // remove the meal from the meals array
            restaurantVar.meals.removeAll { $0.id == meal.id }
        } else {
            // remove the old meal and append the new one with updated quantity
            restaurantVar.meals.removeAll { $0.id == meal.id }
            restaurantVar.meals.append(replaceMeal)
        }
        
        // add meal to active orders
        restaurantVar.activeOrders.append(newMeal)
        print("TESTING RESTAURANTVAR.ACTIVEORDERS: \(restaurantVar.activeOrders)")
        
        //updateRestaurant(restaurantVar)
        self.currentRestaurant = restaurantVar
        
        Task {
                do {
                    // Use Firestore's Encoder to encode the updated restaurant object
                    let encoder = try Firestore.Encoder().encode(restaurantVar)
                    
                    // If restaurant has an ID, update it in Firestore
                    if let restaurantID = restaurantVar.id {
                        try await firestore.collection("restaurants").document(restaurantID).setData(encoder, merge: true)
                        print("Restaurant updated successfully in Firestore.")
                    }
                } catch {
                    print("Failed to update restaurant in Firestore: \(error.localizedDescription)")
                }
            }
        
    }
    
    
    
    
    
    func completeOrderForRestaurant(meal: Meal, restaurantArray: [Restaurant]) {
        // filter to find the restaurant that the meal belongs to and save that in a variable
        let filteredArray = restaurantArray.filter { $0.name == meal.restaurantFrom }
        var restaurantVar = filteredArray[0]
        

        // remove meal from active orders
        restaurantVar.activeOrders.removeAll { $0.id == meal.id }
        
        // add meal to completed orders
        restaurantVar.completedOrders.append(meal)
        
        // update firebase not working
        //updateRestaurant(restaurantVar)
        self.currentRestaurant = restaurantVar
        
        Task {
                do {
                    // Use Firestore's Encoder to encode the updated restaurant object
                    let encoder = try Firestore.Encoder().encode(restaurantVar)
                    
                    // If restaurant has an ID, update it in Firestore
                    if let restaurantID = restaurantVar.id {
                        try await firestore.collection("restaurants").document(restaurantID).setData(encoder, merge: true)
                        print("Restaurant updated successfully in Firestore.")
                    }
                } catch {
                    print("Failed to update restaurant in Firestore: \(error.localizedDescription)")
                }
            }
        
    }
    
}
