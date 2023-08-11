//
//  CapabilitiesVM.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 15/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import UserNotifications
import StoreKit
import MediaPlayer
import PumpyAnalytics

class CapabilitiesViewModel: ObservableObject {
    
    @Published var libraryAccess: Bool = false
    @Published var storeAccess: Bool = false
    @Published var tokenRecieved: Bool = false
    private let storeController = SKCloudServiceController()
    
    init() {
        libraryAccess = checkLibraryAccess()
        checkAppleMusicSub { [weak self] (status) in
            self?.storeAccess = status
        }
    }
    
    func checkLibraryAccess() -> Bool {
        let status = MPMediaLibrary.authorizationStatus()
        return status == .authorized
    }
    
    func checkAppleMusicSub(completion: @escaping (Bool) -> Void) {
        storeController.requestCapabilities { (capabilities, error) in
            guard error == nil else { return }
            if capabilities.contains(.musicCatalogPlayback) {
                completion(true)
            }
        }
        
    }

    func getLibraryAccess() {
        MPMediaLibrary.requestAuthorization { [weak self] (status) in
            guard let self else { return }
            if status == .authorized {
                self.libraryAccess = self.checkLibraryAccess()
            } else {
                print("Not allowed")
            }
        }
    }
    
}
