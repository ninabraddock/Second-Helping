//
//  StatsView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI
import WebKit

let theme_color = Color("main_color_theme")


struct StatsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var PriceData: PriceData
    
//    var enteredOriginalPriceFormatted: Double {
//        return (Double(enteredOriginalPrice) ?? 0) / 100
//    }
//    
//    var enteredReducedPriceFormatted: Double {
//        return (Double(enteredReducedPrice) ?? 0) / 100
//    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Stats!")
                    .font(.largeTitle)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        StatBox(text: "Food Saved",
                                gifName: "food_saved",
                                value:  "\(Double(restaurantViewModel.totalReviewsSubmitted) * 1.3)",
                                subtitle: "pounds")
                        
                        StatBox(text: "CO₂ Avoided",
                                gifName: "CO2",
                                value: "\(Double(restaurantViewModel.totalReviewsSubmitted) * 4.5)",
                                subtitle: "ppm")
                    }
                    
                    HStack(spacing: 20) {
                        StatBox(text: "Money Saved",
                                gifName: "money_gif",
                                value: "$\(PriceData.enteredOriginalPriceFormatted - PriceData.enteredReducedPriceFormatted)",
                                subtitle: "Dollars")
                        
                        StatBox(text: "Meals Saved",
                                gifName: "meal_saved",
                                value: "\(restaurantViewModel.totalReviewsSubmitted)",
                                subtitle: "total")
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .background(.white)
        .onAppear {
            Task {
                await authViewModel.fetchUsers()
                await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
            }
        }
    }
}

struct StatBox: View {
    let text: String
    let gifName: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
            
            GifImageView(gifName)
                .frame(width: 100, height: 75)
            
            Text(value)
                .font(.title3)
                .bold()
            
            Text(subtitle)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
            
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme_color, lineWidth: 3)
        )
    }
}

#Preview {
    StatsView()
//        .environmentObject(RestaurantViewModel)
}
