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
            let user = User(id: result.user.uid, fullName: fullname, email: email, isCustomer: isCustomer, completedOrders: [])
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
    
    // for testing the historyView
    func addCompletedMeal() {
        
        guard var user = currentUser else {
                    print("No current user found.")
                    return
                }
        
        let fakeMeal = Meal(
            bagType: "Test Bag",
            price: 1.5,
            quantity: 1,
            rangePickUpTime: PickUpTime(start: "12:00", end: "12:00"),
            type: "Dinner",
            restaurantFrom: "Test Restaurant"
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
    
    
}
  
