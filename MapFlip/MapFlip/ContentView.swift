//
//  ContentView.swift
//  MapFlip
//
//  Created by Alejandro González on 17/04/26.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var pins = [Location]()
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
    
    var body: some View {
        MapReader { proxy in
            Map(position: $position) {
                ForEach(pins) { pin in
                    Marker(pin.name, coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
                }
            }
            .mapStyle(.hybrid)
            .onTapGesture { position in
                if let coordinates = proxy.convert(position, from: .local) {
                    pins.append(Location(name: "POI", description: "Hola papus", latitude: coordinates.latitude, longitude: coordinates.longitude))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
