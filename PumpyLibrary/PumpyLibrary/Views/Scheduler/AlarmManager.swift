//
//  AlarmData.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation
import FirebaseFirestore
import UserNotifications

public class AlarmManager: ObservableObject {
    
    var username: String?
    var alarmListener: ListenerRegistration?
    @Published public var alarms = [Alarm]()
    
    public init() {}
    
    public func setUp(username: String) {
        self.username = username
        loadOnlineData()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Write
    
    func saveData() {
        sortAlarms()
        saveDataOnline()
        saveDataOffline()
    }
    
    private func saveDataOnline() {
        if let username {
            FireMethods.save(object: alarms,
                             name: username,
                             documentName: K.FStore.alarmCollection,
                             dataFieldName: K.FStore.alarmCollection)
        }
    }
    
    private func saveDataOffline() {
        do {
            let alarms = try PropertyListEncoder().encode(alarms)
            UserDefaults.standard.set(alarms, forKey: K.alarmsKey)
        } catch {
            print("Save data error.")
        }
    }
    
    // MARK: - Create
    
    func addAlarm(alarm: Alarm) {
        alarms.append(alarm)
        saveData()
    }

    // MARK: - Read
    
    public static func loadAlarms() -> [Alarm] {
        guard let alarms = UserDefaults.standard.object(forKey: K.alarmsKey) as? Data else { return [] }
        return (try? PropertyListDecoder().decode([Alarm].self, from: alarms)) ?? []
    }
    
    private func loadOnlineData() {
        if let username {
            alarmListener = FireMethods.listen(name: username,
                                               documentName: K.FStore.alarmCollection,
                                               dataFieldName: K.FStore.alarmCollection,
                                               decodeObject: [Alarm].self) { [weak self] alarms in
                self?.alarms = alarms
                self?.sortAlarms()
                self?.saveDataOffline()
            }
        }
    }
    
    func loadOtherUsersData(from otherUser: String) {
        FireMethods.get(name: otherUser,
                        documentName: K.FStore.alarmCollection,
                        dataFieldName: K.FStore.alarmCollection,
                        decodeObject: [Alarm].self) { [weak self] alarms in
            guard let self = self else { return }
            self.alarms = alarms
            self.saveData()
        }
    }
    
    // MARK: - Update
    
    func updateAlarm(alarm: Alarm) {
        alarms.removeAll(where: { $0.uuid == alarm.uuid })
        alarms.append(alarm)
        saveData()
    }
    
    // MARK: - Delete
    
    func deleteAlarm(alarm: Alarm) {
        alarms.removeAll(where: { $0 == alarm })
        saveData()
    }
    
    // MARK: - Helpers
    
    public func removeObservers() {
        alarmListener?.remove()
    }
    
    func sortAlarms() {
        alarms = alarms.sortAlarms()
    }

}


