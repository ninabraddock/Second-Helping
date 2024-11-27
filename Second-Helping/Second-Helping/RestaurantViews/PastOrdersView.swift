//
//  HistoryView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct PastOrdersView: View {
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @State private var selectedQuantity: Int = 0
    


    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                VStack {
                    Text("Order History")
                        .font(.custom("StudyClash", size: 40))
                        .foregroundColor(Color.customGreen)
                        .padding([.bottom, .top], 20)
                    
                    // Check if currentUser exists
                    if let currentRestaurant = restaurantViewModel.currentRestaurant {
                        // Display orders if the user is fetched
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(currentRestaurant.completedOrders) { order in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(order.bagType)") // Assuming order has a bagType
                                            .font(.custom("StudyClash", size: 22))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Text("Qty: \(order.quantity)") // Assuming order has a quantity
                                            .font(.custom("StudyClash", size: 18))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.bottom, 2)
                                    
                                    Text("Price: $\(String(format: "%.2f", order.reducedPrice))")
                                        .font(.custom("StudyClash", size: 18))
                                        .foregroundColor(.black)
                                    
                                    Text("Customer Name: \(order.mealOrderUser)")
                                        .font(.custom("StudyClash", size: 18))
                                        .foregroundColor(.black)
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color.customGreen)
                                        .padding(.bottom, 5)
                                }
                            }
                            Spacer()
                        }
                        .padding([.leading, .trailing], 25)
                    } else {
                        Text("Loading orders...")
                    }
                }
                Spacer()
            }
        }
        .background(.white)
    }
}


#Preview {
    PastOrdersView()
}
