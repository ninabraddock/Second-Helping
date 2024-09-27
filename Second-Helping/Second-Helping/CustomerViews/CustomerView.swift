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
                let customGreen = Color(hex: "#4f7942")
                VStack {
                    Text("Browse food options")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(customGreen)
                    // Section for Dinner
                    HStack{
                        Text("Dinner")
                            .underline()
                            .font(.title2)
                            .padding()
                        Spacer()
                        NavigationLink(destination: StatsView()) {
                            Text("See All")
                                .padding()
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            SearchView(
                                image: Image("waterworks"),
                                quantity: Int(3),
                                name: "Waterworks",
                                bagType: "Mystery Bag",
                                rangePickUpTime: "5:30 pm - 6:00 pm",
                                ranking: 4.3,
                                distance: 0.3,
                                price: 15.00,
                                btnHandler: nil
                            )
                            SearchView(
                                image: Image("PhoHong"),
                                quantity: Int(2),
                                name: "Pho Hong",
                                bagType: "Mystery Bag",
                                rangePickUpTime: "8:30 pm - 9:00 pm",
                                ranking: 4.8,
                                distance: 1.1,
                                price: 4.50,
                                btnHandler: nil
                            )
                        }
                    }

                    // Section for Lunch
                    HStack{
                        Text("Lunch")
                            .underline()
                            .font(.title2)
                            .padding()
                        Spacer()
                        NavigationLink(destination: StatsView()) {
                            Text("See All")
                                .padding()
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            SearchView(
                                image: Image("theGriffin"),
                                quantity: Int(4),
                                name: "The Griffin",
                                bagType: "Mystery Bag",
                                rangePickUpTime: "1:00 pm - 1:45 pm",
                                ranking: 4.4,
                                distance: 0.8,
                                price: 5.50,
                                btnHandler: nil
                            )
                            SearchView(
                                image: Image("blueBird"),
                                quantity: Int(2),
                                name: "BlueBird Barbeque",
                                bagType: "Mystery Bag",
                                rangePickUpTime: "12:15 pm - 1:15 pm",
                                ranking: 3.2,
                                distance: 0.6,
                                price: 6.00,
                                btnHandler: nil
                            )
                        }
                    }
                }
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
