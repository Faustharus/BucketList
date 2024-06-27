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
    
    var onSave: (Location) -> Void
    
    @State private var viewModel: ViewModel
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $viewModel.name)
                    TextField("Details", text: $viewModel.details)
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
                        let newLocation = viewModel.createNewPlaces()
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
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

#Preview {
    EditView(location: .exampleLocation) { _ in }
}
