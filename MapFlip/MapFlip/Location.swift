//
//  Location.swift
//  MapFlip
//
//  Created by Alejandro González on 22/04/26.
//

import Foundation

struct Location : Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
}
