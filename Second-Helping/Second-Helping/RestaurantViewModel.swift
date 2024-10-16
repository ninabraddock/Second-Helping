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
                let data = document.data()
//                print("Fetched document data: \(data)") // Log fetched document data
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
    func addRestaurant(_ restaurant: Restaurant) async throws {
        do {
            let encoder = try Firestore.Encoder().encode(restaurant)
            // Generate a new document ID
            let documentRef = firestore.collection("restaurants").document()
            var restaurantWithID = restaurant
            restaurantWithID.id = documentRef.documentID  // Set the document ID before saving
            try await documentRef.setData(encoder)
            await fetchRestaurants()
        } catch {
            print("Debug: failed to add restaurant with error \(error.localizedDescription)")
            throw error
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
}
