//
//  HistoryView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedQuantity: Int = 0
    var body: some View {
        VStack{
            Text("Order History")
                .font(.largeTitle)
                .padding([.bottom, .top], 20)
//            Spacer()
            
            // top -> bottom, new -> old
            VStack(alignment: .leading, spacing: 0){
                HStack {
                    Text("Restaurant Name")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star")
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
                    Text("Restaurant Name")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.fill")
                    Image(systemName: "star.leadinghalf.fill")
                    Image(systemName: "star")
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
//            .border(Color.black, width: 3)
        }
        Spacer()
    }
}

#Preview {
    HistoryView()
}
