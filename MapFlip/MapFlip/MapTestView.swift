//
//  MapTestView.swift
//  MapFlip
//
//  Created by Alejandro González on 18/04/26.
//

import MapKit
import SwiftUI

struct LocationMK : Identifiable {
    let id = UUID()
    var name : String
    var coordinate : CLLocationCoordinate2D
}


struct MapTestView: View {
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    
    let locations = [
        LocationMK(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        LocationMK(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    
    var body: some View {
        VStack {
            MapReader { proxy in
                Map(position: $position, interactionModes: [.all]) {
                    ForEach(locations) { location in
                        //Marker(location.name, coordinate: location.coordinate)
                        Annotation(location.name, coordinate: location.coordinate) {
                            Text(location.name)
                                .font(.headline.bold())
                                .padding()
                                .glassEffect(.clear)
                                .foregroundStyle(.white)
                                .clipShape(.capsule)
                        }
                    }
                }
                .mapStyle(.hybrid)
                .onMapCameraChange(frequency: .onEnd) { context in
                    print(context.camera)
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print(coordinate)
                    }
                }
            }
            
            HStack(spacing: 50) {
                Button("London") {
                    position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                }
                
                Button("Paris") {
                    position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                }
                
                Button("Tokyo") {
                    position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                }

            }
        }
    }
}

#Preview {
    MapTestView()
}
