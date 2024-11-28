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
                    .font(.custom("StudyClash", size: 40))
                    .foregroundColor(Color.customGreen)
                    .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Spacer()
                        StatBox(text: "Food Saved",
                                gifName: "food_saved",
                                value:  "\(Double(totalCompletedOrderQuantity) * 1.3)",
                                subtitle: "pounds")
                        
                        StatBox(text: "CO₂ Avoided",
                                gifName: "CO2",
                                value: "\(Double(totalCompletedOrderQuantity) * 4.5)",
                                subtitle: "ppm")
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        Spacer()
                        StatBox(text: "Money Saved",
                                gifName: "money_gif",
                                value: "\(moneySavedFormatted)",
                                subtitle: "Dollars")
                        
                        StatBox(text: "Meals Saved",
                                gifName: "meal_saved",
                                value: "\(totalCompletedOrderQuantity)",
                                subtitle: "total")
                        Spacer()
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
    
    var moneySavedFormatted: String {
        guard let completedOrders = authViewModel.currentUser?.completedOrders else {
            return "0.00"
        }
        
        var savingsSum = 0.00
        
        for order in completedOrders {
            savingsSum += order.originalPrice - order.reducedPrice
        }
        
        return String(format: "%.2f", savingsSum)
    }
    
    var totalCompletedOrderQuantity: Int {
        guard let completedOrders = authViewModel.currentUser?.completedOrders else {
            return 0
        }
        
        var quantitySum = 0
        for order in completedOrders {
            quantitySum += order.quantity
        }
        return quantitySum
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
                .font(.custom("StudyClash", size: 28))
                .multilineTextAlignment(.center)
            
            GifImageView(gifName)
                .frame(width: 100, height: 75)
            
            Text(value)
                .font(.custom("StudyClash", size: 26))
            
            Text(subtitle)
                .font(.custom("StudyClash", size: 26))
                .multilineTextAlignment(.center)
            
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(theme_color, lineWidth: 3)
        )
    }
}

#Preview {
    StatsView()
        .environmentObject(AuthViewModel())
        .environmentObject(RestaurantViewModel())
        .environmentObject(PriceData())
}
