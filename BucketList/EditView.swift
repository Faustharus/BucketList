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
    
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String = ""
    @State private var details: String = ""
    
    @State private var viewModel = ViewModel()
    
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
                    Button("Delete") {
                        // TODO: Delete Function: Later
                    }
                    .disabled(true)
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces(places: location)
            }
        }
    }
}

#Preview {
    EditView(location: .exampleLocation) { _ in }
}
