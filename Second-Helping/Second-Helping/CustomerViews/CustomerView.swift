//
//  CustomerView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct CustomerView: View {
    // Setting this to false should cause the customer to "log out"
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Button(action: {
                    isLoggedIn = false
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(Color.red)
                }
                .padding()
            }
            
            Spacer()
            
            TabView {
                SearchView()
                    .tabItem() {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                FavoritesView()
                    .tabItem() {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                
                LocationView()
                    .tabItem() {
                        Image(systemName: "location.fill.viewfinder")
                        Text("Location")
                    }
                
                HistoryView()
                    .tabItem() {
                        Image(systemName: "gobackward")
                        Text("History")
                    }
                
                StatsView()
                    .tabItem() {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Stats")
                    }
            }
        }
    }
}


#Preview {
    CustomerView(isLoggedIn: .constant(true))
}
