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
    
    @State private var selectedLocation: Location?

    var body: some View {
        MapReader { proxy in
            Map(position: $position) {
                ForEach(pins) { pin in
                    Annotation(pin.name, coordinate: pin.coordinates) {
                        Image(systemName: "heart.circle")
                            .resizable()
                            .foregroundStyle(.pink)
                            .frame(width: 30, height: 30)
                            .background(.white)
                            .clipShape(.circle)
                            .onTapGesture { }
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        selectedLocation = pin
                                    }
                            )
                    }
                    
                }
            }
            .mapStyle(.standard)
            .onTapGesture { position in
                if let coordinates = proxy.convert(position, from: .local) {
                    pins.append(Location(id: UUID(), name: "POI", description: "Hola papus", latitude: coordinates.latitude, longitude: coordinates.longitude))
                }
            }
        }
        .sheet(item: $selectedLocation) { location in
            EditView(location: location) { newLocation in
                if let index = pins.firstIndex(of: location) {
                    pins[index] = newLocation
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
