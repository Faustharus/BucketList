//
//  ContentView.swift
//  BucketList
//
//  Created by Damien Chailloleau on 13/06/2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.23, longitude: 2.21), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var viewModel = ViewModel()
    
    @State private var modes: mapModeStyle = .standard
    
    var body: some View {
        if viewModel.isUnlocked {
            VStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(selectedMapStyle)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(point: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
                Picker("", selection: $modes) {
                    ForEach(mapModeStyle.allCases, id: \.self) { item in
                        Text("\(item.rawValue.capitalized)")
                    }
                }
                .pickerStyle(.segmented)
                .padding()
            }
        } else {
            Button {
                viewModel.authenticate()
            } label: {
                Text("Unlock")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .frame(width: 150, height: 65)
                    .foregroundStyle(.white)
                    .background(.blue.gradient)
                    .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 10, topTrailing: 0)))
            }
        }
    }
}

#Preview {
    ContentView()
}

// MARK: Computed Properties
extension ContentView {
    
    var selectedMapStyle: MapStyle {
        switch modes {
        case .standard:
            return .standard
        case .hybrid:
            return .hybrid
        }
    }
    
}
