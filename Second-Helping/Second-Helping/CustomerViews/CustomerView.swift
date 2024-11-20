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
    @Binding var isCustomer: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Second Helping")
                    .font(.custom("StudyClash", size: 28))
                    .underline()
                    .foregroundColor(Color.customGreen)
                    .padding([.horizontal, .top])
                Spacer()
                Button(action: {
                    isLoggedIn = false
                    isCustomer = false
                    isCustomer = true
                }) {
                    Text("Logout")
                        .font(.custom("StudyClash", size: 24))
                        .foregroundColor(Color.red)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                        )
                }
                .padding([.horizontal, .top])
            }
            
            ZStack(alignment: .top) {
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
                
                SquigglyDividerTopBG()
                    .fill(.white)
                    .frame(height: 10)
                SquigglyDivider()
                    .stroke(Color.customGreen, lineWidth: 3)
                    .frame(height: 10)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}


#Preview {
    CustomerView(isLoggedIn: .constant(true), isCustomer: .constant(true)).environmentObject(RestaurantViewModel())
}
