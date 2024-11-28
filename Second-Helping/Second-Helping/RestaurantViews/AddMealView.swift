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



class PriceData: ObservableObject {
    @Published var enteredOriginalPrice: String = ""
    @Published var enteredReducedPrice: String = ""
    
    var enteredOriginalPriceFormatted: Double {
        return (Double(enteredOriginalPrice) ?? 0) / 100
    }

    var enteredReducedPriceFormatted: Double {
        return (Double(enteredReducedPrice) ?? 0) / 100
    }
}

struct AddMeal: View {
    @EnvironmentObject var PriceData: PriceData
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var restaurantName: String = ""

    // Form Variables
    @State private var newMeal: Meal = Meal(bagType:"", originalPrice:0, reducedPrice:0, quantity:0, rangePickUpTime: PickUpTime(start:"", end:""), type:"", restaurantFrom: "", mealOrderUser: "")
    
    @State private var enteredQuantity = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var hasAddedMeal = false
    
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
        ZStack {
            Form{
                
                // Bag type Section
                Section(header:
                            Text("Bag Type")
                    .font(.custom("StudyClash", size: 18))
                ) {
                    Picker("Select Bag Type", selection: $newMeal.bagType) {
                        ForEach(bagTypes, id: \.self) { bagType in
                            Text(bagType)
                                .font(.custom("StudyClash", size: 18))
                        }
                    }
                    .font(.custom("StudyClash", size: 18))
                }
                
                // Original Price Section
                Section(header:
                            Text("Original Price")
                    .font(.custom("StudyClash", size: 18))
                ) {
                    ZStack(alignment: .leading) {
                        TextField("", text: $PriceData.enteredOriginalPrice)
                            .font(.custom("StudyClash", size: 18))
                            .keyboardType(.numberPad).foregroundColor(.clear)
                            .textFieldStyle(PlainTextFieldStyle())
                            .disableAutocorrection(true)
                            .accentColor(.clear)
                        Text("$\(PriceData.enteredOriginalPriceFormatted, specifier: "%.2f")")
                            .font(.custom("StudyClash", size: 18))
                    }
                    .onChange(of: PriceData.enteredOriginalPriceFormatted) { newValue in
                        newMeal.originalPrice = newValue
                    }
                }
                
                // Reduced Price Section
                Section(header:
                            Text("Reduced Price")
                    .font(.custom("StudyClash", size: 18))
                ) {
                    ZStack(alignment: .leading) {
                        TextField("", text: $PriceData.enteredReducedPrice)
                            .font(.custom("StudyClash", size: 18))
                            .keyboardType(.numberPad).foregroundColor(.clear)
                            .textFieldStyle(PlainTextFieldStyle())
                            .disableAutocorrection(true)
                            .accentColor(.clear)
                        Text("$\(PriceData.enteredReducedPriceFormatted, specifier: "%.2f")")
                            .font(.custom("StudyClash", size: 18))
                    }
                    .onChange(of: PriceData.enteredReducedPriceFormatted) { newValue in
                        newMeal.reducedPrice = newValue
                    }
                }
                
                // Quantity Section
                Section(header:
                            Text("Quantity")
                    .font(.custom("StudyClash", size: 18))
                ) {
                    TextField("Enter Quantity", text: $enteredQuantity)
                        .font(.custom("StudyClash", size: 18))
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
                Section(header:
                            Text("Pickup Start Time")
                    .font(.custom("StudyClash", size: 18))
                ) {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                        .font(.custom("StudyClash", size: 18))
                        .datePickerStyle(WheelDatePickerStyle())
                        .onChange(of: startTime) {
                            newMeal.rangePickUpTime.start = timeFormatter.string(from: startTime)
                        }
                }
                
                .onAppear() {
                    newMeal.rangePickUpTime.start = timeFormatter.string(from: startTime)
                }
                
                // Pickup End Time Section
                Section(header:
                            Text("Pickup End Time")
                    .font(.custom("StudyClash", size: 18))
                ) {
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                        .font(.custom("StudyClash", size: 18))
                        .datePickerStyle(WheelDatePickerStyle())
                        .onChange(of: endTime) {
                            newMeal.rangePickUpTime.end = timeFormatter.string(from: endTime)
                        }
                }
                .onAppear() {
                    newMeal.rangePickUpTime.end = timeFormatter.string(from: endTime)
                }
                
                
                // Meal Type Section
                Section(header:
                            Text("Meal Type")
                    .font(.custom("StudyClash", size: 18))
                ) {
                    Picker("Select Meal Type", selection: $newMeal.type) {
                        ForEach(mealTypes, id: \.self) { mealType in
                            Text(mealType)
                                .font(.custom("StudyClash", size: 18))
                        }
                    }
                    .font(.custom("StudyClash", size: 18))
                }
                
                let isValid = formValid(newMeal: newMeal, pickupStartTime: startTime, pickupEndTime: endTime)
                
                Section {
                    Button {
                        Task {
                            await addNewMeal(newMeal: newMeal, restaurantHandler: restaurantViewModel)
                            hasAddedMeal = true
                        }
                    } label: {
                        HStack {
                            Text("Add Meal")
                                .font(.custom("StudyClash", size: 24))
                            Image(systemName: "plus")
                        }
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        .background(Color.customGreen)
                        .cornerRadius(10)
                    }
                    .disabled(!isValid)
                    // grayout btn
                    .opacity(isValid ? 1 : 0.5)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
                .listRowBackground(Color.clear)
            } //end form
            .background(.white)
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
            
            
            if hasAddedMeal {
                Text("Meal Added!")
                    .font(.custom("StudyClash", size: 16))
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)
                    .background(Color.customGreen)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                hasAddedMeal = false
                            }
                        }
                    }
            }
        }

    }
}

@MainActor func addNewMeal(newMeal: Meal, restaurantHandler: RestaurantViewModel) async {
    // adding a meal to a restaurant
    print("ADDING MEAL")
    var mealToAdd = newMeal
    // set the UUID for the meal
    mealToAdd.id = UUID()
    if let curRestaurant = restaurantHandler.currentRestaurant {
        var updatedRestaurant = curRestaurant
        updatedRestaurant.meals.append(mealToAdd)
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
    
    if newMeal.originalPrice <= 0 {
        return false
    }
    if newMeal.reducedPrice <= 0 && newMeal.reducedPrice <= newMeal.originalPrice {
        return false
    }
    
    if newMeal.quantity <= 0 {
        return false
    }
    
    // make sure user has entered pick up time corrctly
    if pickupStartTime == pickupEndTime ||
        pickupStartTime >= pickupEndTime{
        return false
    }
    
    // at least 30 minute pick up time window
    let timeDifference = pickupEndTime.timeIntervalSince(pickupStartTime)
    if timeDifference < 30 * 60 {
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

