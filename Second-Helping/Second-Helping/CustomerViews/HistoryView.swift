//
//  HistoryView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI


func ratingToStars(rating: Double) -> [Image] {
    var starArray: [Image] = []
    var numStars = 0
    
    for i in 1...Int(rating) {
        starArray.append(Image(systemName: "star.fill"))
        numStars += 1
    }
    
    if (rating.remainder(dividingBy: 1)) >= 0.5 {
        starArray.append(Image("star.leadinghalf.fill"))
        numStars += 1
    }
    
    for i in 1...(5 - numStars) {
        starArray.append(Image("star"))
    }
    return starArray
}

func getOrderStatus(order: Meal, restaurantArray: [Restaurant]) -> String {
    let filterArray = restaurantArray.filter { $0.name == order.restaurantFrom}
    var restaurant = filterArray[0]
    let isActive = restaurant.activeOrders.contains(where: { $0.id == order.id })
    
    if isActive {
        return "In Progress..."
    } else {
        return "Completed"
    }
}


struct HistoryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var restaurantViewModel: RestaurantViewModel
    @State private var selectedQuantity: Int = 0
    @State private var showReview = false
    @State private var selectedMeal: Meal?
    
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
                    if let currentUser = authViewModel.currentUser {
                        // Display orders if the user is fetched
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(currentUser.completedOrders) { order in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(order.restaurantFrom)
                                            .font(.custom("StudyClash", size: 22))
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            selectedMeal = order
                                            showReview = true
                                        }) {
                                            Text("Leave a Review")
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
                                    
                                    Text("Type of Bag: \(order.bagType)")
                                        .font(.custom("StudyClash", size: 18))
                                    
                                    HStack {
                                        Text("Order Status: \(getOrderStatus(order: order, restaurantArray: restaurantViewModel.restaurants))")
                                            .font(.custom("StudyClash", size: 18))
                                        
                                        Spacer()
                                        
                                        Text("Qty: \(order.quantity)")
                                            .font(.custom("StudyClash", size: 18))
                                    }
                                    
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color(UIColor.lightGray))
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
                .sheet(isPresented: $showReview) {
                    if let meal = selectedMeal {
                        LeaveReview(meal: meal)
                    }
                }
                .onChange(of: showReview) {
                    Task {
                        await authViewModel.fetchUsers()
                        await restaurantViewModel.fetchRestaurants()
                    }
                }
                Spacer()
            }
        }
        .background(.white)
        .onAppear {
            Task {
                await authViewModel.fetchUsers()
                print("Fetched completed orders: \(authViewModel.currentUser?.completedOrders)")
            }
        }
    }
}


#Preview {
    HistoryView()
}
