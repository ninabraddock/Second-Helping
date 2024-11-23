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
        HStack {
            Spacer()
            VStack {
                Text("Order History")
                    .font(.largeTitle)
                    .padding([.bottom, .top], 20)
                
                // Check if currentUser exists
                if let currentRestaurant = restaurantViewModel.currentRestaurant {
                    // Display orders if the user is fetched
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(currentRestaurant.completedOrders) { order in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(currentRestaurant.name)
                                        .font(.title3)
                                    
                                    Spacer()
                                    
                                }
                                
                                HStack {
                                    Text("Type of Bag: \(order.bagType)") // Assuming order has a bagType
                                    Spacer()
                                    Text("Qty: \(order.quantity)") // Assuming order has a quantity
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .background(Color(UIColor.lightGray))
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
        .background(.white)
    }
}


#Preview {
    PastOrdersView()
}
