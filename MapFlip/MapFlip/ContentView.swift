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
            ZStack(alignment: .bottomTrailing) {
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
                .mapStyle(viewModel.isHybrid ? .hybrid : .standard)
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
                
            Button {
                viewModel.isHybrid.toggle()
            } label: {
                Image(systemName: (viewModel.isHybrid ? "square.2.layers.3d.bottom.filled" : "square.2.layers.3d.top.filled"))
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(.circle)
            .offset(x: -15, y: -20)
            .shadow(radius: 2, x: 1, y: 1)
                
            }
            .ignoresSafeArea()
        } else {
            ZStack {
                Map(initialPosition: position)
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .foregroundStyle(.ultraThinMaterial)
                Button("Unlock pins", action: viewModel.authenticate)
            }
            .alert("Flopped whilst unlocking pins", isPresented: $viewModel.showingAuthAlert) {
                    
            } message: {
                Text(viewModel.authAlertMessage)
            }
        }
    }
}

#Preview {
    ContentView()
}
