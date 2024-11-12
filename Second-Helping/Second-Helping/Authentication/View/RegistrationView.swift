//
//  RegistrationView.swift
//  Second-Helping
//
//  Created by Nina Braddock on 10/3/24.
//

import SwiftUI
import CoreLocation

struct RegistrationView: View {
    @State private var registrationStatus: Bool = false
    @State private var showError: Bool = false
    
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var addr1 = ""
    @State private var addr2 = ""
    @State private var city = ""
    @State private var state = ""
    @State private var postalCode = ""
    @State private var country = ""
    @State private var isCustomer = true
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var loadingState: LoadingState
    
    // Address validation
    @State private var isAddressValid: Bool? = nil
    private func validateAddress() async {
        let fullAddr = "\(addr1), \(addr2.isEmpty ? "" : addr2 + ", ")\(city), \(state) \(postalCode), \(country)"
        let (latitude, longitude) = await getCoordinates(from: fullAddr)
        
        isAddressValid = (latitude != nil && longitude != nil)
    }
    
    // Phone number format validation
    @State private var isPhoneNumberValid: Bool? = nil
    private func validatePhoneNumber() async {
        // This pattern accepts numbers like "+1234567890", "(123) 456-7890", "123-456-7890", etc.
        let phonePattern = #"^\+?[0-9]{1,4}?[-.●]?(\(?\d{1,3}?\)?[-.●]?)?[-.●]?\d{1,4}[-.●]?\d{1,4}[-.●]?\d{1,9}$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phonePattern)
        isPhoneNumberValid = phonePredicate.evaluate(with: phoneNumber)
    }
    
    var formIsValid: Bool {
            let isRestaurantFieldsFilled = !phoneNumber.isEmpty
                && (isPhoneNumberValid == true)
                && !addr1.isEmpty
                && !city.isEmpty
                && !state.isEmpty
                && !postalCode.isEmpty
                && !country.isEmpty
                && (isAddressValid == true) // address must be validated

            return !email.isEmpty
                && email.contains("@")
                && !password.isEmpty
                && password.count >= 5
                && !fullName.isEmpty
                && confirmPassword == password
                && confirmPassword.count >= 5
                && (isCustomer || isRestaurantFieldsFilled)
        }
    
    var body: some View {
        ScrollView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.top, 16)
                
                Text("Second Helping")
                    .font(.custom("StudyClash", size: 34))
                    .padding(.bottom, 24)
                
                VStack(spacing: 20){
                    
                    Picker("User Type", selection: $isCustomer) {
                        Text("Customer").tag(true)
                        Text("Restaurant").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.bottom, .horizontal])
                    
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@emaple.com")
                    // emails don't start with caps
                    .autocapitalization(.none)
                    
                    if isCustomer {
                        InputView(text: $fullName,
                                  title: "Full Name",
                                  placeholder: "Enter your full name")
                    } else {
                        InputView(text: $fullName,
                                  title: "Restaurant Name",
                                  placeholder: "Enter restaurant name")
                    }
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                    ZStack(alignment: .trailing){
                        InputView(text: $confirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your password",
                                  isSecureField: true)
                        
                        // && password != confirmPassword
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(.systemRed))
                            }
                        }
                    }
                    if !isCustomer {
                        InputView(text: $phoneNumber,
                                  title: "Phone Number",
                                  placeholder: "Enter phone number")
                        .keyboardType(.phonePad)
                        
                        InputView(text: $addr1,
                                  title: "Address Line 1",
                                  placeholder: "Street address")
                        
                        InputView(text: $addr2,
                                  title: "Address Line 2",
                                  placeholder: "Apt, suite, building (optional)")
                        
                        InputView(text: $city,
                                  title: "City",
                                  placeholder: "Enter city")
                        
                        InputView(text: $state,
                                  title: "State",
                                  placeholder: "Enter state")
                        
                        InputView(text: $postalCode,
                                  title: "Postal Code",
                                  placeholder: "Enter postal code")
                        
                        InputView(text: $country,
                                  title: "Country",
                                  placeholder: "Enter country")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                Spacer()
                
                // Error message
                if showError {
                    Text("Error registering account")
                        .font(.custom("StudyClash", size: 18))
                        .foregroundStyle(.red)
                }
                
                // Sign in button
                Button {
                    Task {
                        loadingState.isLoading = true
                        showError = false
                        if isCustomer {
                            registrationStatus = await registerCustomer()
                        } else {
                            registrationStatus = await registerRestaurant()
                        }
                        loadingState.isLoading = false
                        if registrationStatus {
                            // Return to login on successful registration
                            dismiss()
                        } else {
                            showError = true
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .font(.custom("StudyClash", size: 24))
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1 : 0.5)
                .cornerRadius(10)
                .padding(.vertical, 16)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3){
                        Text("Already have an account?")
                        Text("Sign In")
                            .fontWeight(.bold)
                    }
                    .font(.custom("StudyClash", size: 18))
                }
                .padding(.bottom, 16)
            }
            .onChange(of: addr1) { Task { await validateAddress() } }
            .onChange(of: addr2) { Task { await validateAddress() } }
            .onChange(of: city) { Task { await validateAddress() } }
            .onChange(of: state) { Task { await validateAddress() } }
            .onChange(of: postalCode) { Task { await validateAddress() } }
            .onChange(of: country) { Task { await validateAddress() } }
            .onChange(of: phoneNumber) { Task { await validatePhoneNumber()}}
        }
    }
    
    // Function to get latitude and longitude from the address
    private func getCoordinates(from address: String) async -> (latitude: Double?, longitude: Double?) {
        let geocoder = CLGeocoder()
        return await withCheckedContinuation { continuation in
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let location = placemarks?.first?.location {
                    continuation.resume(returning: (location.coordinate.latitude, location.coordinate.longitude))
                } else {
                    print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                    continuation.resume(returning: (nil, nil))
                }
            }
        }
    }
    
    private func registerCustomer() async -> Bool {
        do {
            return try await authViewModel.createUser(withEmail: email, password: password, fullname: fullName, isCustomer: isCustomer)
        } catch {
            print("Error registering customer: \(error.localizedDescription)")
            return false
        }
    }

    private func registerRestaurant() async -> Bool {
        let fullAddr = "\(addr1), \(addr2.isEmpty ? "" : addr2 + ", ")\(city), \(state) \(postalCode), \(country)"
        let (latitude, longitude) = await getCoordinates(from: fullAddr)
        
        guard let latitude = latitude, let longitude = longitude else {
            print("Could not retrieve coordinates")
            return false
        }
        
        let newRestaurant = Restaurant(
            address: fullAddr,
            latitude: latitude,
            longitude: longitude,
            name: fullName,
            phoneNumber: phoneNumber,
            meals: [],
            reviews: [],
            completedOrders: []
        )
        
        do {
            var registrationResult = try await authViewModel.createUser(withEmail: email, password: password, fullname: fullName, isCustomer: isCustomer)
            if registrationResult {
                registrationResult = try await restaurantViewModel.addRestaurant(newRestaurant)
                if !registrationResult {
                    // Something went wrong with creating the restaurant, lets delete the account we just created
                    let deleteResult = await authViewModel.deleteAccount(email: email, password: password)
                    if !deleteResult {
                        print("ERROR DELETING ACCOUNT")
                    }
                }
            }
            return registrationResult
        } catch {
            print("Error registering restaurant: \(error.localizedDescription)")
            return false
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
        .environmentObject(RestaurantViewModel())
}
