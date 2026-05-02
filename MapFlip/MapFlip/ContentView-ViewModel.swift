//
//  ContentView-ViewModel.swift
//  MapFlip
//
//  Created by Alejandro González on 02/05/26.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var pins: [Location]
        var selectedLocation: Location?
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        var isUnlocked = false
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                
                pins = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                print(error.localizedDescription)
                pins = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(pins)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Flopped saving data")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            pins.append(Location(id: UUID(), name: "POI", description: "Hola papus", latitude: point.latitude, longitude: point.longitude))
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedLocation else { return }
            if let index = pins.firstIndex(of: selectedLocation) {
                pins[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            
            var error: NSError?
            
            let reason = "Please authenticate yourself to unlock pins"
            
            if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    if (success) {
                        self.isUnlocked = true
                    } else {
                        //flop
                    }
                }
            } else {
                //Device is ancestral or hasn't configured biometrics yet
            }
        }
    }
}
