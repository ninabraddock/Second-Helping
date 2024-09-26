//
//  LocationView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI
import MapKit

// In the future this will pull locations from some database
extension CLLocationCoordinate2D {
    static let trattoriaCoordinate = CLLocationCoordinate2D(latitude: 44.475460, longitude: -73.213821)
    static let phoCoordinate = CLLocationCoordinate2D(latitude: 44.488918, longitude: -73.207169)
    static let kountyCoordinate = CLLocationCoordinate2D(latitude: 44.475780, longitude: -73.212967)
    static let cortijoCoordinate = CLLocationCoordinate2D(latitude: 44.478120, longitude: -73.212010)
    static let givenCoordinate = CLLocationCoordinate2D(latitude: 44.479010, longitude: -73.193770)
    static let waterworksCoordinate = CLLocationCoordinate2D(latitude: 44.490238, longitude: -73.184059)
}

struct LocationView: View {

    var body: some View {
        ZStack {
            // In the future when there are more locations, use a for loop to make the map
            // Need to get and show user location
            // Need to make it so that you can click on these locations 
            Map {
                Marker("Trattoria Deli", systemImage: "fork.knife", coordinate: .trattoriaCoordinate)
                Marker("Pho Hong", systemImage: "fork.knife", coordinate: .phoCoordinate)
                Marker("Kountry Kart Deli", systemImage: "fork.knife", coordinate: .kountyCoordinate)
                Marker("El Cortijo Taqueria", systemImage: "fork.knife", coordinate: .cortijoCoordinate)
                Marker("The Given Bistro", systemImage: "fork.knife", coordinate: .givenCoordinate)
                Marker("Waterworks Food + Drink", systemImage: "fork.knife", coordinate: .waterworksCoordinate)
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .including([])))
        }
    }
}

#Preview {
    LocationView()
}
