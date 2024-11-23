//
//  HistoryView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct ActiveOrdersView: View {
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var authViewModel: AuthViewModel


    var body: some View {
        var allUsers = authViewModel.users
        HStack {
            Spacer()
            VStack {
                Text("Active Orders")
                    .font(.largeTitle)
                    .padding([.bottom, .top], 20)
                
                // Check if currentUser exists
                if let currentRestaurant = restaurantViewModel.currentRestaurant {
                    // Display orders if the restaurant is fetched
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(currentRestaurant.activeOrders) { order in
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
                                    Spacer()
                                    Text("Customer Name: \(order.mealOrderUser)")
                                    Button(action: {
                                        //  move this to active orders view:
                                        
                                        authViewModel.completeOrderForUser(meal: order, userArray: allUsers)
                                        restaurantViewModel.completeOrderForRestaurant(meal: order, restaurantArray: restaurantViewModel.restaurants)
                                    }) {
                                        Text("Complete Order")
                                    }
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .background(Color(UIColor.lightGray))
                            }
                        }
                        Spacer()
                    }
                    .padding([.leading, .trailing], 25)
                    .onAppear {
                        Task {
                            await authViewModel.fetchUsers() // Fetch users on view appear
                        }
                    }
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
    ActiveOrdersView()
}
