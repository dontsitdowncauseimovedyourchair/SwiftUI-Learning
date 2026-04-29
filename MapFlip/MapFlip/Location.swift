//
//  Location.swift
//  MapFlip
//
//  Created by Alejandro González on 22/04/26.
//

import MapKit
import Foundation

struct Location : Identifiable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinates : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Example pro", description: "A super cool place to be happy", latitude: 21.1619, longitude: -86.8515)
    #endif
    
    static func==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
