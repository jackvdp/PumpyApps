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
    
    public var username: Username?
    var settingsListener: ListenerRegistration?
    private var overrideTimer: Timer?
    
    @Published public var onlineSettings = SettingsModel() {
        didSet {
            saveSettings(settings: onlineSettings)
            postSettings()
            revertScheduleOverride()
        }
    }
    
    public init() {}
    
    public func setUp(username: Username) {
        self.username = username
        downloadSettings()
    }
    
    deinit {
        print("deiniting SM")
    }
    
    func downloadSettings() {
        if let username {
            settingsListener = FireMethods.listen(name: username,
                                                  documentName: K.FStore.settings,
                                                  dataFieldName: K.FStore.settings,
                                                  decodeObject: SettingsDTOModel.self) { [weak self] settings in
                self?.onlineSettings = settings.toDomain()
            }
        }
    }
    
    public func removeSettingsListener() {
        settingsListener?.remove()
        overrideTimer?.invalidate()
    }
    
    func saveSettings(settings: SettingsModel) {
        if let username {
            FireMethods.save(object: settings,
                             name: username,
                             documentName: K.FStore.settings,
                             dataFieldName: K.FStore.settings)
        }
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
