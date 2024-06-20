//
//  EditView.swift
//  BucketList
//
//  Created by Damien Chailloleau on 16/06/2024.
//

import MapKit
import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
//    enum LoadingState {
//        case loading, loaded, failed
//    }
    
    var location: Location
    var onSave: (Location) -> Void
    
    var mapModes: [MapStyle] = [.standard, .hybrid]
    
    @State private var name: String = ""
    @State private var details: String = ""
//    @State private var loadingState: LoadingState = .loading
//    @State private var pages = [Page]()
    
    @State private var viewModel = ViewModel()
    @State private var isMapHybrid: Bool = false
    @State private var changeMapModes: MapStyle = .standard
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _details = State(initialValue: location.details)
        
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // TODO: Picker for Map Style Modes
                }
                
                Section {
                    TextField("Name", text: $name)
                    TextField("Details", text: $details)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                            + Text(": ") +
                            Text(page.details)
                                .italic()
                        }
                    case .failed:
                        Text("Try again later.")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        var newLocation = location
                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.details = details
                        
                        onSave(newLocation)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Change Style") {
                        
                    }
                }
            }
            .task {
//                await fetchNearbyPlaces()
                await viewModel.fetchNearbyPlaces(places: location)
            }
        }
    }
}

#Preview {
    EditView(location: .exampleLocation) { _ in }
}

extension EditView {
    
//    func fetchNearbyPlaces() async {
//        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
//        
//        guard let url = URL(string: urlString) else {
//            print("Wrong URL !")
//            return
//        }
//        
//        let decoder = JSONDecoder()
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let items = try decoder.decode(Result.self, from: data)
//            
//            pages = items.query.pages.values.sorted()
//            loadingState = .loaded
//        } catch {
//            loadingState = .failed
//        }
//    }
    
}
