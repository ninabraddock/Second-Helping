//
//  RestaurantView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

// TODO: Make/add function to save the data to firebase
// Finish Validation
// Make pretier

import SwiftUI

struct AddMeal: View {
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel

    // Form Variables
    @State private var selectedBagType: String = "Mystery Bag"
    @State private var price: String = ""
    @State private var quantity: String = ""
    @State private var pickupStartHour: Int = 0
    @State private var pickupStartMin: Int = 0
    @State private var pickupEndHour: Int = 0
    @State private var pickupEndMin: Int = 0
    @State private var type: String = "Dinner"
    
    var bagTypes = ["Mystery Bag", "Meal Prep"]
    var mealTypes = ["Lunch", "Dinner"]
    
    var body: some View {
        
        Form{
            
            // Bag type Section
            Section(header: Text("Bag Type")) {
                Picker("Select Bag Type", selection: $selectedBagType) {
                    ForEach(bagTypes, id: \.self) { bagType in
                        Text(bagType)
                    }
                }
            }
            
            // Price Section
            Section(header: Text("Price")) {
                TextField("Enter Price", text: $price)
                    .keyboardType(.decimalPad)
            }
            
            // Quantity Section
            Section(header: Text("Quntity")) {
                TextField("Enter Quantity", text: $quantity)
                    .keyboardType(.decimalPad)
            }
            
            // Pickup Start Time Section
            Section(header: Text("Pickup Start Time")) {
                HStack{
                    Picker("Time", selection: $pickupStartHour) {
                        ForEach(1..<13) { hour in
                            Text("\(hour)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    
                    Text(":")
                    
                    Picker("",selection: $pickupStartMin) {
                        ForEach(1..<60) { minute in
                            Text(String(format: "%02d", minute))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            
            // Pickup End Time Section
            Section(header: Text("Pickup End Time")) {
                HStack{
                    Picker("Time", selection: $pickupEndHour) {
                        ForEach(1..<13) { hour in
                            Text("\(hour)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    
                    Text(":")
                    
                    Picker("",selection: $pickupEndMin) {
                        ForEach(1..<60) { minute in
                            Text(String(format: "%02d", minute))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            
            
            // Meal Type Section
            Section(header: Text("Meal Type")) {
                Picker("Select Meal Type", selection: $type) {
                    ForEach(mealTypes, id: \.self) { mealType in
                    Text(mealType)}
                }
            }
            
        } //end form
        
        let isValid = formValid(price: price, quantity: quantity, pickupStartHour: pickupStartHour, pickupEndHour: pickupEndHour)
        
        Button {
            //addMeal() // Call the addMeal function when the button is pressed
        } label: {
            HStack {
                Text("Add Meal")
                    .fontWeight(.semibold)
                Image(systemName: "plus")
            }
            .foregroundStyle(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color(.systemBlue))
        .disabled(!isValid) // Disable button if form is not valid
        .opacity(isValid ? 1 : 0.5) // Adjust opacity based on form validity
        .cornerRadius(10)
        .padding(.top, 24)

    }
}

func addNewMeal(quantity: String, bagType: String, pickupStartHour: Int, pickupStartMin: Int, pickupEndMin: Int, pickupEndHour: Int, ranking: Double, distance: Double, price: String) {
    // ask jason if we can use code from online for images
    
    let pickupRange: String = "\(pickupStartHour):\(pickupStartMin):\(pickupEndHour):\(pickupEndMin)"
    
    ProductCard(
        image: Image("theGriffin"),
        quantity: Int(quantity)!,
        name: "The Griffin", // get the name from the login info
        bagType: bagType,
        rangePickUpTime: pickupRange,
        ranking: ranking,
        distance: distance,
        price: Double(price)!,
        btnHandler: nil
    )
    
    // adding a meal to a restaurant
    
}


func formValid(price: String, quantity: String, pickupStartHour: Int, pickupEndHour: Int) -> Bool {

    // price validation
    if let firstCharacter = price.first {
        // First character is a digit
        let isFirstValid = firstCharacter.isNumber
        
        // Check for no spaces
        let hasNoSpaces = price.contains(" ")
        
        // Check that it only contains numbers, ".", or "-"
        let isValidCharacters = price.allSatisfy { $0.isNumber || $0 == "." || $0 == "-" }
        
        // Check for one of each "." and "-"
        let dotCount = price.filter { $0 == "." }.count
        if !isFirstValid && !hasNoSpaces && !isValidCharacters && dotCount == 0 {
            return false
        }
    }
    
    // quantity validation
    guard Int(quantity) != nil else {
        return false
    }
    if let quantityInt = Int(quantity){
        if quantityInt <= 0{
            return false
        }
    }
    
    //Time validation
    if pickupStartHour > pickupEndHour {
        return false
    }
    
    return true
    
}


#Preview {
    AddMeal().environmentObject(RestaurantViewModel())
}

