import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    @EnvironmentObject var loadingState: LoadingState
    @Binding var isLoggedIn: Bool
    @Binding var isCustomer: Bool
    @Binding var isRestaurant: Bool
    @State var incorrectInfo = false
    @State var errorMessage = ""
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .padding(.top, 16)
                    
                    Text("Second Helping")
                        .font(.largeTitle)
                        .padding(.bottom, 16)
                    
                    Picker("User Type", selection: $isCustomer) {
                        Text("Customer").tag(true)
                        Text("Restaurant").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.bottom, .horizontal])
                    
                    VStack(spacing: 20){
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
                    
                    Spacer()
                    
                    if incorrectInfo {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                    
                    // Sign in button
                    Button {
                        Task {
                            loadingState.isLoading = true
                            incorrectInfo = try await authViewModel.signIn(withEmail: email, password: password)
                            if !incorrectInfo {
                                if !isCustomer {
                                    // We have a restaurant user
                                    if let curUser = authViewModel.currentUser {
                                        if !curUser.isCustomer {
                                            // Let's try to figure out which restaurant they belong to
                                            for restaurant in restaurantViewModel.restaurants {
                                                if restaurant.name == authViewModel.currentUser?.fullName {
                                                    restaurantViewModel.currentRestaurant = restaurant
                                                }
                                            }
                                            if restaurantViewModel.currentRestaurant == nil {
                                                incorrectInfo = true
                                                errorMessage = "No restaurant associated with account"
                                            }
                                        } else {
                                            // Customer is trying to log in as a restaurant
                                            incorrectInfo = true
                                            errorMessage = "Incorrect account type"
                                            authViewModel.signOut()
                                        }
                                    } else {
                                        incorrectInfo = true
                                        errorMessage = "Error accessing account"
                                        authViewModel.signOut()
                                    }
                                    if !incorrectInfo {
                                        if let _ = restaurantViewModel.currentRestaurant {
                                            isRestaurant = true
                                        } else {
                                            incorrectInfo = true
                                            errorMessage = "Error accessing restaurant"
                                            authViewModel.signOut()
                                        }
                                    }
                                } else {
                                    if let curUser = authViewModel.currentUser {
                                        if !curUser.isCustomer {
                                            // Restaurant is trying to log in as a customer
                                            incorrectInfo = true
                                            errorMessage = "Incorrect account type"
                                            authViewModel.signOut()
                                        }
                                    } else {
                                        incorrectInfo = true
                                        errorMessage = "Error accessing account"
                                        authViewModel.signOut()
                                    }
                                }
                            } else {
                                incorrectInfo = true
                                errorMessage = "Incorrect login information"
                            }
                            loadingState.isLoading = false
                            // Flip the log in bool to trigger the correct view
                            if !incorrectInfo {
                                isLoggedIn = true
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
                    .padding(.bottom, 16)
                    
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
                    .padding(.bottom, 32)
                    
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
                    .padding(.bottom, 16)
                    
                }
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
    LoginView(isLoggedIn: .constant(true), isCustomer: .constant(false), isRestaurant: .constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(RestaurantViewModel())
        .environmentObject(LoadingState())

}
