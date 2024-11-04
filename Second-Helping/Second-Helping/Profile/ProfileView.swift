//
//  ProfileView.swift
//  Second-Helping
//
//  Created by Nina Braddock on 10/3/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.userSession == nil {
            LoginView(isLoggedIn: .constant(true), isCustomer: .constant(true), isRestaurant: .constant(false))
        } else {
            if let user = authViewModel.currentUser {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Section("General"){
                        HStack {
                            SettingsRowView (imageName: "Gear",
                                             title: "Version",
                                             tintColor: Color(.systemGray))
                            Spacer()
                            
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Section("Account"){
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            tintColor: .red)
                        }
                        
                        Button {
                            print("Delete account..")
    //                        authViewModel.deleteAccount()
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill",
                                            title: "Delete Account",
                                            tintColor: .red)
                        }
                    }
                }
            }
        }
//        if let user = authViewModel.currentUser {
            
//        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
