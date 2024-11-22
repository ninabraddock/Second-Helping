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
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var restaurantName: String = ""

    // Form Variables
    @State private var newMeal: Meal = Meal(bagType:"", price:0, quantity:0, rangePickUpTime: PickUpTime(start:"", end:""), type:"", restaurantFrom: "", mealOrderUser: "")
    
    @State private var enteredPrice = ""
    var enteredPriceFormatted: Double {
        return (Double(enteredPrice) ?? 0) / 100
    }
    
    @State private var enteredQuantity = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var bagTypes = ["--select bag--", "Mystery Bag", "Meal Prep"]
    var mealTypes = ["--select meal--", "Lunch", "Dinner"]
    
    // Formatter for inputing price
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // Formatter for inputing quantity
    private let quantityFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    // Formatter for inputing date
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // 12-hour format with am/pm
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()

    
    var body: some View {
        
        Form{
            
            // Bag type Section
            Section(header: Text("Bag Type")) {
                Picker("Select Bag Type", selection: $newMeal.bagType) {
                    ForEach(bagTypes, id: \.self) { bagType in
                        Text(bagType)
                    }
                }
            }
            
            // Price Section
            Section(header: Text("Price")) {
                ZStack(alignment: .leading) {
                    TextField("", text: $enteredPrice)
                        .keyboardType(.numberPad).foregroundColor(.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .disableAutocorrection(true)
                        .accentColor(.clear)
                    Text("\(enteredPriceFormatted, specifier: "%.2f")")
                }
                .onChange(of: enteredPriceFormatted) {
                    newMeal.price = enteredPriceFormatted
                }
            }
            
            // Quantity Section
            Section(header: Text("Quantity")) {
                TextField("Enter Quantity", text: $enteredQuantity)
                    .keyboardType(.numberPad)
                    .onChange(of: enteredQuantity) {
                        // Update newMeal.quantity only if enteredQuantity is a valid number
                        if let quantity = Int(enteredQuantity), quantity > 0 {
                            newMeal.quantity = quantity
                        } else {
                            newMeal.quantity = 0 // Reset if invalid input
                        }
                    }
            }
            
            // Pickup Start Time Section
            Section(header: Text("Pickup Start Time")) {
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .onChange(of: startTime) {
                        newMeal.rangePickUpTime.start = timeFormatter.string(from: startTime)
                    }
            }
            
            // Pickup End Time Section
            Section(header: Text("Pickup End Time")) {
                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .onChange(of: endTime) {
                        newMeal.rangePickUpTime.end = timeFormatter.string(from: endTime)
                    }
            }
            
            
            // Meal Type Section
            Section(header: Text("Meal Type")) {
                Picker("Select Meal Type", selection: $newMeal.type) {
                    ForEach(mealTypes, id: \.self) { mealType in
                        Text(mealType)
                    }
                }
            }
            
            let isValid = formValid(newMeal: newMeal, pickupStartTime: startTime, pickupEndTime: endTime)
            
            Button {
                Task {
                    await addNewMeal(newMeal: newMeal, restaurantHandler: restaurantViewModel)
                }
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
            
        } //end form
        .onAppear {
            if let uid = authViewModel.userSession?.uid {
                Task {
                    await restaurantViewModel.fetchCurrentRestaurant(uid: uid)
                    restaurantName = restaurantViewModel.currentRestaurant?.name ?? "Unknown Restaurant"
                    newMeal.restaurantFrom = restaurantName.filter {$0 != "\\"}
                }
            } else {
                print("Error: No user session available.")
            }
        }

    }
}

@MainActor func addNewMeal(newMeal: Meal, restaurantHandler: RestaurantViewModel) async {
    // adding a meal to a restaurant
    print("ADDING MEAL")
    if let curRestaurant = restaurantHandler.currentRestaurant {
        var updatedRestaurant = curRestaurant
        updatedRestaurant.meals.append(newMeal)
        do {
            try await restaurantHandler.updateRestaurant(updatedRestaurant)
        } catch {
            print("Could not update restaurant with error \(error.localizedDescription)")
        }
    } else {
        print("Error accessing current restaurant")
    }
    
}


func formValid(newMeal: Meal, pickupStartTime: Date, pickupEndTime: Date) -> Bool {

    if !["Mystery Bag", "Meal Prep"].contains(newMeal.bagType) {
        return false
    }
    
    if newMeal.price <= 0 {
        return false
    }
    
    if newMeal.quantity <= 0 {
        return false
    }
    
    if !["Lunch", "Dinner"].contains(newMeal.type) {
        return false
    }
    
    return true
    
}


#Preview {
    AddMeal().environmentObject(RestaurantViewModel())
}

