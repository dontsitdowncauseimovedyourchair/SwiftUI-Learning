//
//  ContentView.swift
//  MapFlip
//
//  Created by Alejandro González on 17/04/26.
//

import MapKit
import SwiftUI

struct ContentView: View {

    let position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: position) {
                    ForEach(viewModel.pins) { pin in
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
                                            viewModel.selectedLocation = pin
                                        }
                                )
                        }
                        
                    }
                }
                .mapStyle(.standard)
                .onTapGesture { position in
                    if let coordinates = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinates)
                    }
                }
            }
            .sheet(item: $viewModel.selectedLocation) { location in
                EditView(location: location) { newLocation in
                    viewModel.updateLocation(location: newLocation)
                }
            }
        } else {
            ZStack {
                Map(initialPosition: position)
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .foregroundStyle(.ultraThinMaterial)
                Button("Unlock pins", action: viewModel.authenticate)
            }
        }
    }
}

#Preview {
    ContentView()
}
