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
        ScrollView {
            HStack {
                Spacer()
                VStack {
                    Text("Active Orders")
                        .font(.custom("StudyClash", size: 40))
                        .foregroundColor(Color.customGreen)
                        .padding([.bottom, .top], 20)
                    
                    // Check if currentUser exists
                    if let currentRestaurant = restaurantViewModel.currentRestaurant {
                        // Display orders if the restaurant is fetched
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(currentRestaurant.activeOrders) { order in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(order.bagType)") // Assuming order has a bagType
                                            .font(.custom("StudyClash", size: 22))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            //  move this to active orders view:
                                            
                                            //authViewModel.completeOrderForUser(meal: order, userArray: allUsers) ---> moved to mealDetailSheet
                                            restaurantViewModel.completeOrderForRestaurant(meal: order, restaurantArray: restaurantViewModel.restaurants)
                                        }) {
                                            Text("Complete Order")
                                        }
                                        .font(.custom("StudyClash", size: 20))
                                        .background(Color.customGray)
                                        .cornerRadius(8)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 2)
                                        .foregroundColor(Color.customGreen)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.customGreen, lineWidth: 2)
                                        )
                                    }
                                    HStack {
                                        Text("Qty: \(order.quantity)") // Assuming order has a quantity
                                            .font(.custom("StudyClash", size: 18))
                                            .foregroundColor(.black)
                                        Text("Price: $\(String(format: "%.2f", order.reducedPrice))")
                                            .font(.custom("StudyClash", size: 18))
                                            .foregroundColor(.black)
                                            .padding(.leading)
                                    }
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
                        .onAppear {
                            Task {
                                await authViewModel.fetchUsers() // Fetch users on view appear
                            }
                        }
                    } else {
                        Text("Loading orders...")
                            .font(.custom("StudyClash", size: 18))
                    }
                }
                Spacer()
            }
        }
        .background(.white)
    }
}


#Preview {
    ActiveOrdersView()
}
