import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isLoggedIn: Bool
    @State var incorrectInfo = false
    
//    @Binding var isCustomer: Bool
//    @Binding var isRestaurant: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                VStack(spacing: 24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    // emails don't start with caps
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Sign in button
                Button {
                    Task {
                        incorrectInfo = try await authViewModel.signIn(withEmail: email, password: password)
                        if !incorrectInfo {
                            isLoggedIn = true
                        } else {
                            incorrectInfo = true
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
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
                
                if incorrectInfo {
                    Text("The username and password cannot be found.").foregroundColor(.red)
                }
                Spacer()
                
                //sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                
                //forgot password button
                NavigationLink {
                    ForgotPasswordView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Forgot your password?")
                        Text("Click Here")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                
//                Text("Second Helping")
//                    .font(.largeTitle)
//                    .padding()
//                
//                Spacer()
//                
//                Button(action: {
//                    isCustomer = true
//                }) {
//                    Text("Customer Login")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 200, height: 50)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//                .padding(.bottom, 5)
//                
//                Button(action: {
//                    isRestaurant = true
//                }) {
//                    Text("Restaurant Login")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 200, height: 50)
//                        .background(Color.green)
//                        .cornerRadius(10)
//                }
//                .padding(.bottom)
                
            }
        }
    }
}

// MARK - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 5
        // TODO: add additional requirements
//        && !email.encode(to: String.self).isEmpty
//        && !phone.encode(to: String.self).isEmpty
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(true))
        .environmentObject(AuthViewModel())
//    LoginView(isCustomer: .constant(false), isRestaurant: .constant(false))
}
