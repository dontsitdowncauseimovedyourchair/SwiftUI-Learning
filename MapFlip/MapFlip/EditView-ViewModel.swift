//
//  EditView-ViewModel.swift
//  MapFlip
//
//  Created by Alejandro González on 03/05/26.
//

import Foundation

extension EditView {
    @Observable
    class ViewModel {
        var location : Location
        
        var name : String
        var description : String
        
        var loadingState = LoadingState.loading
        var pages = [Page]()
        
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

        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
    }
}
