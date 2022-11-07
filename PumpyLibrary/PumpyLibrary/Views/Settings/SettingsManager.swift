//
//  SettingsVM.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class SettingsManager: ObservableObject {
    
    public let username: String
    var settingsListener: ListenerRegistration?
    private var overrideTimer: Timer?
    
    @Published public var onlineSettings = SettingsModel() {
        didSet {
            saveSettings(settings: onlineSettings)
            postSettings()
            revertScheduleOverride()
        }
    }
    
    public init(username: String) {
        self.username = username
        downloadSettings()
    }
    
    deinit {
        print("deiniting")
    }
    
    func downloadSettings() {
        let db = Firestore.firestore()
        settingsListener = FireMethods.listen(db: db,
                                              name: username,
                                              documentName: K.FStore.settings,
                                              dataFieldName: K.FStore.settings,
                                              decodeObject: SettingsModel.self) { [weak self] settings in
            self?.onlineSettings = settings
        }
    }
    
    public func removeSettingsListener() {
        settingsListener?.remove()
        overrideTimer?.invalidate()
    }
    
    func saveSettings(settings: SettingsModel) {
        FireMethods.save(object: settings,
                         name: username,
                         documentName: K.FStore.settings,
                         dataFieldName: K.FStore.settings)
    }
    
    func postSettings() {
        NotificationCenter.default.post(name: Notification.Name.SettingsUpdate, object: nil)
    }
    
    func revertScheduleOverride() {
        guard onlineSettings.overrideSchedule else { return }
        let calendar = Calendar(identifier: .gregorian)
        let mostRecentMidnight = calendar.startOfDay(for: Date())
        let nextMorning = calendar.date(byAdding: .hour, value: 30, to: mostRecentMidnight)
        guard let date = nextMorning else { onlineSettings.overrideSchedule = false; return}
        
        overrideTimer = Timer(fire: date, interval: 0, repeats: false) { [weak self] timer in
            timer.invalidate()
            self?.onlineSettings.overrideSchedule = false
        }
        guard let overrideTimer = overrideTimer else { return }
        RunLoop.current.add(overrideTimer, forMode: .common)
    }
    
}
