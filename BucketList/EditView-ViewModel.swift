//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Damien Chailloleau on 19/06/2024.
//

import MapKit
import Observation
import SwiftUI

extension EditView {
    @Observable
    class ViewModel {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var location: Location
        var name: String = ""
        var details: String = ""
        var loadingState: LoadingState = .loading
        var pages = [Page]()
        
        init(location: Location) {
            self.location = location
            
            name = location.name
            details = location.details
        }
        
        func createNewPlaces() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.details = details
            return newLocation
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Wrong URL !")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try decoder.decode(Result.self, from: data)
                
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
    }
}
