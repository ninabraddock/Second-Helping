//
//  LocationView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//


import SwiftUI
import MapKit
import FirebaseFirestore

struct LocationView: View {
    let border_color = Color("border_map_pin")
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // set window
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @EnvironmentObject var restaurantViewModel: RestaurantViewModel
    // to catch duplicate addresses
    @State private var visitedAddresses: Set<String> = []
    @State private var selectedRestaurant: Restaurant?

    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, annotationItems: restaurantViewModel.restaurants) { location in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                ) {
                    Button(action: {
                        selectedRestaurant = location
                    }) {
                        ZStack {
                            // border
                            Image(systemName: "drop.fill")
                                .resizable()
                                .frame(width: 23, height: 31)
                                .rotationEffect(.degrees(180))
                                .foregroundColor(border_color)
                            
                            // frame/main part
                            Image(systemName: "drop.fill")
                                .resizable()
                                .frame(width: 22, height: 30)
                                .rotationEffect(.degrees(180))
                                .foregroundColor(.red)
                            
                            // inner circle
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .offset(y: -4)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                Task {
                    await restaurantViewModel.fetchRestaurants() // Fetch restaurants on view appear
                }
            }
            
            if let restaurant = selectedRestaurant {
                VStack{
                    Spacer()
                    HStack{
                        Text(restaurant.name)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .frame(width: screenWidth/4 * 3, height: screenHeight/6)
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}


#Preview {
    LocationView().environmentObject(RestaurantViewModel())
}
