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
    
    func createUser (withEmail email: String, password: String, fullname: String, isCustomer: Bool) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email, isCustomer: isCustomer)
            let encoder = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encoder)
            await fetchUser()
        } catch {
            print("debug:failed to create user with error\(error.localizedDescription)")
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
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
//        print("Debug: current user is \(String(describing: self.currentUser))")
    }
}
  
