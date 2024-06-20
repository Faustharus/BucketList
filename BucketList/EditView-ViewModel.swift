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
        
        var loadingState: LoadingState = .loading
        var pages: [Page]
        
        init() {
            pages = []
        }
        
        func fetchNearbyPlaces(places: Location) async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(places.latitude)%7C\(places.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
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
