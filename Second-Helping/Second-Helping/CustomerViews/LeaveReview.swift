//
//  Untitled.swift
//  Second-Helping
//
//  Created by user266699 on 11/24/24.
//

import SwiftUI



struct LeaveReview: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var restaurantViewModel: RestaurantViewModel
    let meal: Meal
    @State private var reviewNum: Int = 1
    @State private var reviewText: String = ""
    @State private var hasLeftReview = false
    
    let highestRating = 5
    
    var body: some View {
        VStack(spacing: 20) {

            // stepper for picking Rating
//            Stepper("Rating: \(reviewNum)", value: $reviewNum, in: 1...5)
//                .padding(10)
//                .padding(.horizontal, 15)
//                .font(.custom("StudyClash", size: 20))
//                .background(Color.customGray)
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.customGreen, lineWidth: 2)
//                )
            HStack {
                Text("Leave a Review")
                    .font(.custom("StudyClash", size: 24))
                    .underline()
                    .foregroundColor(Color.customGreen)
                    .padding([.horizontal, .top])
                
                Spacer()
                
                HStack(spacing: 10) {
                    ForEach(1..<highestRating + 1, id: \.self) { index in
                        Button(action: {
                            reviewNum = index
                        }) {
                            if reviewNum >= index {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20))
                            } else {
                                Image(systemName: "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20))
                            }
                        }
                    }
                }
                .padding(10)
            }
            
            TextField("Write in your review here", text: $reviewText)
                .font(.custom("StudyClash", size: 20))
                .padding(10)
                .background(Color.customGray)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.customGreen, lineWidth: 2)
                )
                .padding(.horizontal, 15)
            
            Button(action: {
                if let currentUser = authViewModel.currentUser {
                    print(currentUser.fullName)
                    restaurantViewModel.addReview(meal: meal, restaurantArray: restaurantViewModel.restaurants, rating: reviewNum, textReview: reviewText)
                    hasLeftReview = true
                } else {
                    print("No current user available")
                }
            }) {
                Text("Submit Review")
            }
            .font(.custom("StudyClash", size: 20))
            .foregroundColor(Color.customGreen)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.customGreen.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.customGreen, lineWidth: 2)
                    )
            )
            if hasLeftReview {
                Text("Your review has been submitted")
                    .font(.custom("StudyClash", size: 16))
                    .foregroundColor(Color.customGreen)
                    .padding(.horizontal)
            }
        }
        .padding()
        .border(Color.customGreen, width: 6)
        .onAppear {
                    Task {
                        await restaurantViewModel.fetchRestaurants()
                        await authViewModel.fetchUsers()
                    }
                }
        .presentationDetents([.medium, .large]) // Control the height of the sheet
    }
        
}
