//
//  LocationView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

//import SwiftUI
//import MapKit
//
//// In the future this will pull locations from some database
//extension CLLocationCoordinate2D {
//    static let trattoriaCoordinate = CLLocationCoordinate2D(latitude: 44.475460, longitude: -73.213821)
//    static let phoCoordinate = CLLocationCoordinate2D(latitude: 44.488918, longitude: -73.207169)
//    static let kountyCoordinate = CLLocationCoordinate2D(latitude: 44.475780, longitude: -73.212967)
//    static let cortijoCoordinate = CLLocationCoordinate2D(latitude: 44.478120, longitude: -73.212010)
//    static let givenCoordinate = CLLocationCoordinate2D(latitude: 44.479010, longitude: -73.193770)
//    static let waterworksCoordinate = CLLocationCoordinate2D(latitude: 44.490238, longitude: -73.184059)
//}
//
//struct LocationView: View {
//
//    var body: some View {
//        ZStack {
//            // In the future when there are more locations, use a for loop to make the map
//            // Need to get and show user location
//            // Need to make it so that you can click on these locations 
//            Map {
//                Marker("Trattoria Deli", systemImage: "fork.knife", coordinate: .trattoriaCoordinate)
//                Marker("Pho Hong", systemImage: "fork.knife", coordinate: .phoCoordinate)
//                Marker("Kountry Kart Deli", systemImage: "fork.knife", coordinate: .kountyCoordinate)
//                Marker("El Cortijo Taqueria", systemImage: "fork.knife", coordinate: .cortijoCoordinate)
//                Marker("The Given Bistro", systemImage: "fork.knife", coordinate: .givenCoordinate)
//                Marker("Waterworks Food + Drink", systemImage: "fork.knife", coordinate: .waterworksCoordinate)
//            }
//            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .including([])))
//        }
//    }
//}


import SwiftUI
import MapKit
import FirebaseFirestore

struct LocationView: View {
    // set window
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var locations: [Restaurant] = []
    // to catch duplicate addresses
    @State private var visitedAddresses: Set<String> = []

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { location in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: .red)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            startListeningToRestaurants()
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
