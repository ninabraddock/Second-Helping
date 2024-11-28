//
//  AuthViewModel.swift
//  Second-Helping
//
//  Created by Nina Braddock on 10/3/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var users: [User] = []
    
    private let firestore = Firestore.firestore()
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws -> Bool {
        print("Sign in..")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            return false
        } catch {
            return true
        }
    }
    
    func sendPasswordReset(email: String) async -> (succcess: Bool, message: String?) {
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return (true, "Password reset email sent successfully.")
        } catch {
            return (false, "Error sending password reset email: \(error.localizedDescription)")
        }
        
    }
    
    func createUser (withEmail email: String, password: String, fullname: String, isCustomer: Bool) async throws -> Bool {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email, isCustomer: isCustomer, completedOrders: [], favoriteMeals: [])
            let encoder = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encoder)
            await fetchUser()
            return true
        } catch {
            print("debug:failed to create user with error\(error.localizedDescription)")
            return false
        }
    }
    
    func signOut() {
        do {
            //signs out user backend
            try Auth.auth().signOut()
            // wipes out user session and takes us back to login screen
            self.userSession = nil
            // wipes out curr data model
            self.currentUser = nil
        } catch {
            print("Debug: failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(email: String, password: String) async -> Bool {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user
            print("Debug: User signed in successfully for deletion.")
            
            do {
                try await Firestore.firestore().collection("users").document(user.uid).delete()
                print("Debug: User data deleted from Firestore.")
            } catch {
                print("Debug: Failed to delete user data from Firestore with error \(error.localizedDescription)")
                return false
            }
            
            do {
                try await user.delete()
                self.userSession = nil
                self.currentUser = nil
                print("Debug: User account deleted from Firebase Authentication.")
                return true
            } catch {
                print("Debug: Failed to delete user from Firebase Authentication with error \(error.localizedDescription)")
                return false
            }
        } catch {
            print("Debug: Failed to sign in for account deletion with error \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
//        print("Debug: current user is \(String(describing: self.currentUser))")
    }
    
    // Fetch a specific restaurant by ID
    func fetchUser(withID id: String) async {
        do {
            let document = try await firestore.collection("users").document(id).getDocument()
            var user = try? document.data(as: User.self)
            user?.id = document.documentID  // Set the document ID manually
            self.currentUser = user
        } catch {
            print("Debug: failed to fetch user with error \(error.localizedDescription)")
        }
    }
    
    // Fetch all users
    
    func fetchUsers() async {
        print("FETCHING USERS")
        do {
            let snapshot = try await firestore.collection("users").getDocuments()
            self.users = snapshot.documents.compactMap { document in
                // Attempt to decode the restaurant
                do {
                    var user = try document.data(as: User.self)
                    user.id = document.documentID // Set the document ID
                    print("Decoded user: \(String(describing: user))")
                    return user
                } catch {
                    // Print the error details
                    print("Error decoding user: \(error)")
                    return nil // Return nil if decoding fails
                }

            }
            // Keep our same current restaurant
            if let curUser =  currentUser {
                if !curUser.id.isEmpty {
                    await fetchUser(withID: curUser.id)
                } else {
                    // We don't have an id for that user, lets try to find a user with that name
                    let userName = curUser.fullName
                    for user in users {
                        if user.fullName == userName {
                            currentUser = user
                        }
                    }
                    
                }
            }
            print("USERS FETCHED")
        } catch {
            print("Debug: failed to fetch users with error \(error.localizedDescription)")
        }
    }

    

    
    // for testing the historyView
    func addDummyCompletedMeal() {
        
        guard var user = currentUser else {
                    print("No current user found.")
                    return
                }
        
        let fakeMeal = Meal(
            bagType: "Test Bag",
            originalPrice: 3.5,
            reducedPrice: 1.5,
            quantity: 1,
            rangePickUpTime: PickUpTime(start: "12:00", end: "12:00"),
            type: "Dinner",
            restaurantFrom: "Test Restaurant",
            mealOrderUser: ""
            )
        
        user.completedOrders.append(fakeMeal)
        self.currentUser = user
        Task {
                    do {
                        let encoder = try Firestore.Encoder().encode(user)
                        try await Firestore.firestore().collection("users").document(user.id).setData(encoder)
                        print("Fake meal added successfully.")
                    } catch {
                        print("Failed to add fake meal to Firestore: \(error.localizedDescription)")
                    }
                }
        
    }
    
    func completeOrderForUser(meal: Meal, restaurantArray: [Restaurant], quantity: Int, orderID: UUID) {
        // filter to find the restaurant that the meal belongs to and save that in a variable
        let filteredArray = restaurantArray.filter { $0.name == meal.restaurantFrom }
        var restaurantVar = filteredArray[0]
        
        guard var currentUser = self.currentUser else {
            print("No current user found.")
            return
        }
        
        var newMeal = meal
        newMeal.quantity = quantity
//        if let matchingMeal = restaurantVar.activeOrders.first(where: { $0.id == newMeal.id }) {
//            newMeal.quantity = matchingMeal.quantity
//        } else {
//            print("Meal not found in active orders.")
//        }
        
        // Append the meal to the completed orders of the current user
        newMeal.id = orderID
        currentUser.completedOrders.append(newMeal)
        self.currentUser = currentUser
        Task {
            do {
                let encoder = try Firestore.Encoder().encode(currentUser)
                try await Firestore.firestore().collection("users").document(currentUser.id).setData(encoder)
                print("Meal completed successfully.")
            } catch {
                print("Failed to complete complete meal: \(error.localizedDescription)")
            }
        }
    }
    
    func testFetchUsers() async{
        await fetchUsers()
        print(users)
    }
    
    func addFavoriteMeal(mealId: String) {
        // Ensure we have a current user
        guard var user = currentUser else {
            print("No current user found.")
            return
        }
        
        // Check if the meal is already in the favorites
        if !user.favoriteMeals.contains(mealId) {
            // Add the meal ID to the favoriteMeals array
            user.favoriteMeals.append(mealId)
            
            // Update the Firestore document for the current user
            Task {
                do {
                    let encoder = try Firestore.Encoder().encode(user)
                    try await Firestore.firestore().collection("users").document(user.id).setData(encoder)
                    print("Meal added to favorites successfully.")
                } catch {
                    print("Failed to add meal to favorites: \(error.localizedDescription)")
                }
            }
        } else {
            print("Meal is already in the favorites.")
        }
    }
    
    func removeFavoriteMeal(mealId: String) {
        // Ensure we have a current user
        guard var user = currentUser else {
            print("No current user found.")
            return
        }
        
        // Remove the meal ID from the favoriteMeals array if it exists
        if let index = user.favoriteMeals.firstIndex(of: mealId) {
            user.favoriteMeals.remove(at: index)
            
            // Update the Firestore document for the current user
            Task {
                do {
                    let encoder = try Firestore.Encoder().encode(user)
                    try await Firestore.firestore().collection("users").document(user.id).setData(encoder)
                    print("Meal removed from favorites successfully.")
                } catch {
                    print("Failed to remove meal from favorites: \(error.localizedDescription)")
                }
            }
        } else {
            print("Meal was not found in the favorites.")
        }
    }
    
}
  
