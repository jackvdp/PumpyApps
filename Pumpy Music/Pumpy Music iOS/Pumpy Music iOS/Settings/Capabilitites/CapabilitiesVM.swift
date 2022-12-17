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
import PumpyAnalytics

class CapabilitiesViewModel: ObservableObject {
    
    @Published var notificationsAllowed: Bool = false
    @Published var libraryAccess: Bool = false
    @Published var storeAccess: Bool = false
    @Published var tokenRecieved: Bool = false
    
    init() {
        checkNotificationsAllowed { [weak self] (status) in
            self?.notificationsAllowed = true
        }
        libraryAccess = checkLibraryAccess()
        checkAppleMusicSub { [weak self] (status) in
            self?.storeAccess = status
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
    
    let storeController = SKCloudServiceController()
    
    func getToken() {
        storeController.requestUserToken(forDeveloperToken: PumpyAnalytics.K.MusicStore.developerToken) { [weak self] token, errror in
            if let _ = token {
                self?.tokenRecieved = true
            } else {
                if let e = errror {
                    print(e)
                }
            }
        }
    }
    
    let notificationCentre = UNUserNotificationCenter.current()
    
    func getNotificationAccesss() {
        notificationCentre.requestAuthorization(options: [.alert, .sound, .badge, .carPlay]) { [weak self] (granted, error) in
            if granted {
                self?.checkNotificationsAllowed { (status) in
                    self?.notificationsAllowed = true
                }
            } else {
                print("Not allowed.")
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
