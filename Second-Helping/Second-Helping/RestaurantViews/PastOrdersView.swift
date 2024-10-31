//
//  PastOrders.swift
//  Second-Helping
//
//  Created by Nina Braddock on 10/28/24.
//

import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "x.square.fill")

                configuration.label
            }
        })
    }
}


struct PastOrders: View {
    @State private var selectedQuantity = 0
    @State private var hasPickedUp = true
    
    var body: some View {
        VStack{
            Text("Past Orders")
                .font(.largeTitle)
                .padding([.bottom, .top], 20)
//            Spacer()
            
            // top -> bottom, new -> old
            VStack(alignment: .leading, spacing: 0){
                HStack {
                    // TODO: replace -> unique to each order
                    Toggle(isOn: $hasPickedUp){
                        Text("Customer Name")
                            .font(.title3)
                    }
                        .toggleStyle(iOSCheckboxToggleStyle())
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    // TODO: Time picked up
                    Text("2:00 pm")
                }
                
                
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
                HStack {
                    // TODO: replace -> unique to each order
                    Toggle(isOn: $hasPickedUp){
                        Text("Customer Name")
                            .font(.title3)
                    }
                        .toggleStyle(iOSCheckboxToggleStyle())
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("Pick Up Time: _____")
                }
                
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
        }
        Spacer()
    }
}

#Preview {
    PastOrders()
}
