//
//  RestaurantView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct RestaurantView: View {
    // Setting this to false should cause the restaurant to "log out"
    @Binding var isLoggedIn: Bool
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Button(action: {
                    isLoggedIn = false
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(Color.red)
                }
                .padding()
            }
            
            Spacer()
            
            Text("Restaurant View")
                .font(.largeTitle)
            
            Spacer()
            
        }
        .padding()
    }
}


#Preview {
    RestaurantView(isLoggedIn: .constant(true))
}
