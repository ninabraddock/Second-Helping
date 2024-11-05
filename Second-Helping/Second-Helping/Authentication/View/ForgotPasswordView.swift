//
//  ForgotPasswordView.swift
//  Second-Helping
//
//  Created by Charlie Corriero on 11/3/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var updateMessage: String? = nil
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            VStack(spacing: 24){
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@emaple.com")
                // emails don't start with caps
                .autocapitalization(.none)

                }

            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // update button
            Button {
                Task {

                    let result = await authViewModel.sendPasswordReset(email: email)
                    updateMessage = result.message
                    
                }
            } label: {
                HStack {
                    Text("RESET PASSWORD")
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
            .padding(.top, 24)
            
            if let message = updateMessage {
                Text(message)
                    .fontWeight(.semibold)
                    .padding(.top, 16)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3){
                    Text("Back to login")
                    Text("Click Here")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }


// MARK - AuthenticationFormProtocol

extension ForgotPasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
    }
}

#Preview {
    ForgotPasswordView().environmentObject(AuthViewModel())
}
