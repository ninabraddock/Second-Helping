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
        VStack(spacing: 0) {
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
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
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
            .padding(.bottom, 12)
            .background(Color.customGreen.opacity(0.3))
            
            ZStack(alignment: .top) {
                ZStack {

                    TabView {
                        Group {
                            ZStack {
                                Color.customGreen
                                SearchView()
                                    .padding(.horizontal, 8)
                            }
                        }
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                            }
                        
                        Group {
                            ZStack {
                                Color.customGreen
                                FavoritesView()
                                    .padding(.horizontal, 8)
                            }
                        }
                            .tabItem {
                                Image(systemName: "star.fill")
                                Text("Favorites")
                            }
                        
                        LocationView()
                            .tabItem {
                                Image(systemName: "location.fill.viewfinder")
                                Text("Location")
                            }
                        
                        Group {
                            ZStack {
                                Color.customGreen
                                HistoryView()
                                    .padding(.horizontal, 8)
                            }
                        }
                            .tabItem {
                                Image(systemName: "gobackward")
                                Text("History")
                            }
                        
                        Group {
                            ZStack {
                                Color.customGreen
                                StatsView()
                                    .padding(.horizontal, 8)
                            }
                        }
                            .tabItem {
                                Image(systemName: "chart.bar.xaxis")
                                Text("Stats")
                            }
                    }
                    .onAppear() {
//                        UITabBar.appearance().isTranslucent = false
                        UITabBar.appearance().backgroundColor = .white
                    }
                }
                
                // Squiggly dividers for styling
                SquigglyDividerTopBG()
                    .fill(Color.white)
                    .frame(height: 10)
                SquigglyDividerTopBG()
                    .fill(Color.customGreen.opacity(0.3))
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
