//
//  EditView.swift
//  MapFlip
//
//  Created by Alejandro González on 24/04/26.
//

import SwiftUI

enum LoadingState {
    case loading, loaded, failed
}

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    var onSave : (Location) -> Void

    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby Places") {
                    switch viewModel.loadingState {
                    case .loading:
                        LoadingView()
                    case .loaded:
                        ForEach(viewModel.pages, id:\.pageid) { page in
                            Text(page.title).font(.headline) + Text(": ") + Text(page.description).italic()
                        }
                    case .failed:
                        Text("Flopped")
                    }
                }
            }
            .navigationTitle("Edit Pin")
            .toolbar {
                Button("Save", role: .confirm) {
                    let newLocation = viewModel.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.findNearby()
            }
        }
    }
    
    
    init(location: Location, onSave: @escaping (Location)->Void) {
        self.viewModel = ViewModel(location: location)
        self.onSave = onSave
    }
}

#Preview {
    EditView(location: .example) { _ in
        
    }
}
