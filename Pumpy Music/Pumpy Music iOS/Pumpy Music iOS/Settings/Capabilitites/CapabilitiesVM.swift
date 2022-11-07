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
import PumpyLibrary

class CapabilitiesViewModel: ObservableObject {
    
    @Published var notificationsAllowed: Bool = false
    @Published var libraryAccess: Bool = false
    @Published var storeAccess: Bool = false
    @Published var tokenRecieved: Bool = false
    
    init() {
        checkNotificationsAllowed { (status) in
            self.notificationsAllowed = true
        }
        libraryAccess = checkLibraryAccess()
        checkAppleMusicSub { (status) in
            self.storeAccess = status
        }
        getToken()
    }
    
    func checkNotificationsAllowed(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                completion(true)
            }
        }
    }
    
    func checkLibraryAccess() -> Bool {
        let status = MPMediaLibrary.authorizationStatus()
        if status == .authorized {
            return true
        } else {
            return false
        }
    }
    
    func checkAppleMusicSub(completion: @escaping (Bool) -> Void) {
        let controller = SKCloudServiceController()
        controller.requestCapabilities { (capabilities, error) in
            guard error == nil else { return }
            if capabilities.contains(.musicCatalogPlayback) {
                completion(true)
            }
        }
        
    }
    
    func getToken() {
        SKCloudServiceController().requestUserToken(forDeveloperToken: K.MusicStore.developerToken) { token, errror in
            if let _ = token {
                self.tokenRecieved = true
            } else {
                if let e = errror {
                    print(e)
                }
            }
        }
    }
    
    func getNotificationAccesss() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay]) { (granted, error) in
            if granted {
                self.checkNotificationsAllowed { (status) in
                    self.notificationsAllowed = true
                }
            } else {
                print("Not allowed.")
            }
        }
    }
    
    func getLibraryAccess() {
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.libraryAccess = self.checkLibraryAccess()
            } else {
                print("Not allowed")
            }
        }
    }
    
}
