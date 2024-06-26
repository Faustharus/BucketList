//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Damien Chailloleau on 18/06/2024.
//

import CoreLocation
import Foundation
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked: Bool = false
        
        var isDevicePasscodeInUse: Bool = false
        
        let secAccessControlObject: SecAccessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .devicePasscode, nil)!
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPath")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation(point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New Location", details: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        // FIXME: To put in the EditView-ViewModel ???
//        func delete(at offsets: IndexSet) {
//            locations.remove(atOffsets: offsets)
//        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            let reason = "Data's app needs to be unlocked to resume."
            
//            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//                let reason = "Data's app needs to be unlocked to resume."
//                
//                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                    if success {
//                        self.isUnlocked = true
//                    } else {
//                        self.isUnlocked = false
//                    }
//                }
//            } else {
//                context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
//            }
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.isUnlocked = false
                        self.isDevicePasscodeInUse = true
                    }
                }
            } else {
                // No biometrics
                if isDevicePasscodeInUse {
                    context.evaluateAccessControl(secAccessControlObject, operation: .createKey, localizedReason: reason) { success, authenticationError in
                        // TODO: More Code Later
                        if success {
                            self.isUnlocked = true
                        } else {
                            // An issue has been detected
                        }
                    }
                }
            }
        }
    }
}

//                context.evaluateAccessControl(SecAccessControlCreateWithFlags(.none, CFTypeRef.biometry(fallback: .devicePasscode), .devicePasscode, .allocate(capacity: 1))!, operation: LAAccessControlOperation.useItem, localizedReason: "") { success, error in
//                    // TODO: Later
//                }
