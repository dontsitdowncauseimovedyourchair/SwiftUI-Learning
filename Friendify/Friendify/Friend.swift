//
//  Friend.swift
//  Friendify
//
//  Created by Alejandro González on 31/03/26.
//

import Foundation

struct Friend : Hashable, Identifiable, Codable {
    let id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}


