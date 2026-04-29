//
//  EditView.swift
//  MapFlip
//
//  Created by Alejandro González on 24/04/26.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    var location : Location
    var onSave : (Location) -> Void

    @State private var name : String
    @State private var description : String
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Edit Pin")
            .toolbar {
                Button("Save", role: .confirm) {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location)->Void) {
        self.onSave = onSave
        self.location = location
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
        
    }
}

#Preview {
    EditView(location: .example) {_ in}
}
