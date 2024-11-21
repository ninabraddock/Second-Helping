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
    
    @State private var locations: [Restaurant] = []
    // to catch duplicate addresses
    @State private var visitedAddresses: Set<String> = []
    @State private var selectedRestaurant: Restaurant?

    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, annotationItems: locations) { location in
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
                startListeningToRestaurants()
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

    private func startListeningToRestaurants() {
        let db = Firestore.firestore()
        
        // init data, documents is the second column or all entries of restaurants
        db.collection("restaurants").getDocuments { (snapshot, error) in
            if let error = error {
                print("error getting initial restaurants: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("no restaurants found")
                return
            }
            
            
            print("total restaurants found (initially): \(documents.count)")
            for document in documents {
                let data = document.data()
                
                if data["id"] == nil { print("missing 'id' field: \(document.documentID)") }
                if data["address"] == nil { print("missing 'address' field: \(document.documentID)") }
                if data["latitude"] == nil { print("missing 'latitude' field: \(document.documentID)") }
                if data["longitude"] == nil { print("missing 'longitude' field: \(document.documentID)") }
                if data["name"] == nil { print("missing 'name' field: \(document.documentID)") }
                if data["phoneNumber"] == nil { print("missing 'phoneNumber' field: \(document.documentID)")}

                
                // get fields
                guard let id = data["id"] as? String,
                      let address = data["address"] as? String,
                      let latitude = data["latitude"] as? Double,
                      let longitude = data["longitude"] as? Double,
                      let name = data["name"] as? String,
                      let phoneNumber = data["phoneNumber"] as? String
                        
                else {
                    print("missing required fields in restaurant document.")
                    continue
                }
                
                // instance
                let restaurant = Restaurant(
                    id: id,
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                    name: name,
                    phoneNumber: phoneNumber,
                    meals: [],
                    reviews: [],
                    completedOrders: []
                )
                
                print("\(name) address: \(address)")

                // don't add again
                if !visitedAddresses.contains(address) {
                    locations.removeAll() { $0.id == id}
                    locations.append(restaurant)
                    visitedAddresses.insert(address)
                    print("added restaurants from initial: \(name)")
                }
            }
        }
        
        // add listener for updates after init
        db.collection("restaurants").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("error getting snapshot: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                let data = diff.document.data()
                
                // get the fields
                guard let id = data["id"] as? String,
                      let address = data["address"] as? String,
                      let latitude = data["latitude"] as? Double,
                      let longitude = data["longitude"] as? Double,
                      let name = data["name"] as? String,
                      let phoneNumber = data["phoneNumber"] as? String
                else {
                    print("missing fields in restaurant")
                    return
                }
                // instance
                let restaurant = Restaurant(
                    id: id,
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                    name: name,
                    phoneNumber: phoneNumber,
                    meals: [],
                    reviews: [],
                    completedOrders: []
                )

                switch diff.type {
                case .added:
                    //add only if not added yet
                    if !visitedAddresses.contains(address) {
                        locations.append(restaurant)
                        visitedAddresses.insert(address)
                        print("new restaurant: \(name)")
                    }
                   
                // already exists
                case .modified:
                    if let index = locations.firstIndex(where: { $0.id == id }) {
                        locations[index] = restaurant
                        print("restaurant updated: \(name)")
                    }
                  
                // if deleted
                case .removed:
                    locations.removeAll { $0.id == id }
                    visitedAddresses.remove(address)
                    print("restaurant removed: \(id)")
                }
            }
        }
    }
}


#Preview {
    LocationView()
}
