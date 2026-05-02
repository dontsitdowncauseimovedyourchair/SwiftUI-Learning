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
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby Places") {
                    switch loadingState {
                    case .loading:
                        LoadingView()
                    case .loaded:
                        ForEach(pages, id:\.pageid) { page in
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
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await findNearby()
            }
        }
    }
    
    func findNearby() async {
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let items = try JSONDecoder().decode(Result.self, from: data)
                        
            pages = items.query.pages.values.sorted()
            
            loadingState = .loaded
        } catch {
            print("Error: \(error.localizedDescription)")
            loadingState = .failed
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
