//
//  RegistrationView.swift
//  Second-Helping
//
//  Created by Nina Braddock on 10/3/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isCustomer = true
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding(.top, 16)
            
            Text("Second Helping")
                .font(.largeTitle)
                .padding(.bottom, 16)
            
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
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Spacer()
            
            // Sign in button
            Button {
                Task {
                    try await authViewModel.createUser(withEmail: email, password: password, fullname: fullName, isCustomer: isCustomer)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            // grayout btn
            .opacity(formIsValid ? 1 : 0.5)
            .cornerRadius(10)
            .padding(.bottom, 16)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3){
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            .padding(.bottom, 16)
        }
    }
}

// MARK - AuthenticationFormProtocol

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 5
        && !fullName.isEmpty
        && confirmPassword == password
        && confirmPassword.count >= 5
        // TODO: add additional requirements
//        && !email.encode(to: String.self).isEmpty
//        && !phone.encode(to: String.self).isEmpty
//        && !username.isEmpty
    }
}

#Preview {
    RegistrationView().environmentObject(AuthViewModel())
}
