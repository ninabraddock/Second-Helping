//
//  LoginView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var isCustomer: Bool
    @Binding var isRestaurant: Bool
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Second Helping")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Button(action: {
                isCustomer = true
            }) {
                Text("Customer Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 5)
            
            Button(action: {
                isRestaurant = true
            }) {
                Text("Restaurant Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            
        }
    }
}


#Preview {
    LoginView(isCustomer: .constant(false), isRestaurant: .constant(false))
}
