//
//  Restaurant.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 10/15/24.
//

import Foundation


struct Restaurant: Identifiable, Codable {
    var id: String?
    var address: String
    var latitude: Double
    var longitude: Double
    var name: String
    var phoneNumber: String
    var meals: [Meal]
    var reviews: [Review]
    var completedOrders: [Meal]
    
    var meanRating: Double {
        guard !reviews.isEmpty else { return 0.0 }
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        let avgRating = Double(totalRating) / Double(reviews.count)
        return (avgRating * 10).rounded() / 10.0
    }
}

struct Meal: Identifiable, Codable {
    var id: UUID? = UUID()
    var bagType: String
    var price: Double
    var quantity: Int
    var rangePickUpTime: PickUpTime
    var type: String
    var restaurantFrom: String
}

struct PickUpTime: Codable {
    var start: String
    var end: String
}

struct Review: Codable {
    var rating: Int
    var text: String
}
