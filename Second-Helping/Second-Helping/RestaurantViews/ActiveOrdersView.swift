//
//  ActiveOrders.swift
//  Second-Helping
//
//  Created by Nina Braddock on 10/28/24.
//

import SwiftUI

struct ActiveOrders: View {
    @State private var selectedQuantity = 0
    
    var body: some View {
        VStack{
            Text("Active Orders")
                .font(.largeTitle)
                .padding([.bottom, .top], 20)
//            Spacer()
            
            // top -> bottom, new -> old
            VStack(alignment: .leading, spacing: 0){
                Text("Customer Name")
                    .font(.title3)
                HStack{
                    Text("Type of Bag")
                    Spacer()
                    
                    Text("Qty")
                    Picker("Quantity", selection: $selectedQuantity) {
                        ForEach(0...10, id: \.self) { quantity in
                            Text("\(quantity)").tag(quantity)
                        }
                    }
                    .frame(width: 50, height: 50)
                    .clipped()
                }
                // TODO: replace w/ number from firebase
                Text("Order Number: 123456")
                    .padding(.bottom)
                Divider()
                    .frame(height: 1)
                    .background(Color(UIColor.lightGray))
            }
            .padding([.leading, .trailing], 25)
            .padding(.bottom, 20)
            
            // second customer
            VStack(alignment: .leading, spacing: 0){
                Text("Customer Name")
                    .font(.title3)
                HStack{
                    Text("Type of Bag")
                    Spacer()
                    
                    Text("Qty")
                    Picker("Quantity", selection: $selectedQuantity) {
                        ForEach(0...10, id: \.self) { quantity in
                            Text("\(quantity)").tag(quantity)
                        }
                    }
                    .frame(width: 50, height: 50)
                    .clipped()
                }
                // TODO: replace w/ number from firebase
                Text("Order Number: 123456")
                    .padding(.bottom)
                Divider()
                    .frame(height: 1)
                    .background(Color(UIColor.lightGray))
            }
            .padding([.leading, .trailing], 25)
//            .border(Color.black, width: 3)
        }
    }
}

#Preview {
    ActiveOrders()
}
