//
//  Location.swift
//  BucketList
//
//  Created by Damien Chailloleau on 15/06/2024.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var details: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG
    static let exampleLocation = Location(id: UUID(), name: "Apple Park", details: "Built by the same architect whom built the 'Viaduc de Millau' in France", latitude: 37.334, longitude: -122.009)
    #endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
