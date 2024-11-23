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


struct HistoryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedQuantity: Int = 0

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Order History")
                    .font(.largeTitle)
                    .padding([.bottom, .top], 20)
                
                
                // Check if currentUser exists
                if let currentUser = authViewModel.currentUser {
                    // Display orders if the user is fetched
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(currentUser.completedOrders) { order in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(order.restaurantFrom) // Assuming order has a restaurantName
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
    HistoryView()
}
