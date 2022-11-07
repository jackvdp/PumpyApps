//
//  ScheduleViewModel.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary
import FirebaseFirestore

class ScheduleViewModel: ObservableObject {
    
    var user: ScheduledUser
    var getPlaylists: () -> [ScheduledPlaylist]
    
    init(user: ScheduledUser, getPlists: @escaping () -> [ScheduledPlaylist]) {
        self.user = user
        self.getPlaylists = getPlists
        loadData()
        loadPlaylists()
    }
    
    @Published var alarmArray = [Alarm]() {
        didSet {
            filterAlarms()
        }
    }
    @Published var alarmArrayToView = [Alarm]()
    @Published var alarmDays: DetailInfo.DaysOfWeek? {
        didSet {
            filterAlarms()
        }
    }
    
    @Published var playlists = [String]()
    @Published var selectedDate = Date()
    @Published var playlistIndex: Int?
    @Published var days = [DetailInfo.DaysOfWeek]()
    @Published var index: Int?
    @Published var secondaryPlaylists = [SecondaryPlaylist]()
    
    @Published var externalSettingsOverride = false
    @Published var showQRCode: Bool = false
    @Published var qrLink = String()
    @Published var qrMessage = String()
    @Published var contentType: ExtDisContentType = .artworkAndTitles
    @Published var messageSpeed: Double = 8.0
    @Published var qrType: QRType = .playlist
    
    func filterAlarms() {
        alarmArrayToView = alarmArray
        if let day = alarmDays {
            alarmArrayToView.removeAll(where: { !$0.repeatStatus.contains(day) && $0.repeatStatus != [] })
        }
    }
    
    func loadData() {
        alarmArray = user.alarmData.alarmArray
    }
    
    func deleteData(at i: Int) {
        alarmArray.remove(at: i)
        user.alarmData.saveData(alarmArray: alarmArray)
    }
    
    func loadPlaylists() {
        let playlistsMM = getPlaylists()
        if !playlistsMM.isEmpty {
            for playlist in playlistsMM {
                playlists.append(playlist.name ?? "")
            }
            playlists.append(K.stopMusic)
        }
    }
    
    func createNewSecondaryPlaylist() {
        let playlistsMM = getPlaylists()
        if let playlist = playlistsMM.first {
            secondaryPlaylists.append(SecondaryPlaylist(name: playlist.name ?? "", ratio: 2))
        }
    }
    
    func setAlarm() {
        if let i = index {
            let a = alarmArray[i]
            selectedDate = Calendar.current.date(bySettingHour: a.time.hour, minute: a.time.min, second: 0, of: Date()) ?? Date()
            days = a.repeatStatus
            playlistIndex = playlists.firstIndex(of: a.playlistLabel)
            if let secPlaylist = a.secondaryPlaylists {
                secondaryPlaylists = secPlaylist
            }
            
            if a.externalSettingsOverride ?? false {
                externalSettingsOverride = a.externalSettingsOverride ?? false
                showQRCode = a.showQRCode ?? false
                qrLink = a.QRLink ?? String()
                qrMessage = a.QRMessage ?? String()
                contentType = a.contentType ?? ExtDisContentType.artworkAndTitles
                messageSpeed = a.messageSpeed ?? 8.0
            }
        }
    }
    
    func saveAlarm() {
        if let i = playlistIndex {
            let newAlarm = createNewAlarm(playlistIndex: i)
            
            if let i = index {
                alarmArray.remove(at: i)
            }
            
            alarmArray.append(newAlarm)
            
            alarmArray.sort {
                if $0.time.date.hour < 6, $1.time.date.hour >= 6 { return false }
                if $1.time.date.hour < 6, $0.time.date.hour >= 6 { return true  }
                return ($0.time.date.hour, $0.time.date.minute) < ($1.time.date.hour, $1.time.date.minute)
            }
            
            user.alarmData.saveData(alarmArray: alarmArray)
        }
    }
    
    func createNewAlarm(playlistIndex i: Int) -> Alarm {
        if externalSettingsOverride {
            return Alarm(uuid: UUID().uuidString,
                         time: Time(hour: selectedDate.hour, min: selectedDate.minute),
                         playlistLabel: playlists[i],
                         repeatStatus: days,
                         secondaryPlaylists: secondaryPlaylists,
                         externalSettingsOverride: externalSettingsOverride,
                         showQRCode: showQRCode,
                         QRLink: qrLink,
                         QRMessage: qrMessage,
                         contentType: contentType,
                         messageSpeed: messageSpeed)
        } else {
            return Alarm(uuid: UUID().uuidString,
                         time: Time(hour: selectedDate.hour, min: selectedDate.minute),
                         playlistLabel: playlists[i],
                         repeatStatus: days,
                         secondaryPlaylists: secondaryPlaylists)
        }
    }
    
    func resetAlarm() {
        playlistIndex = nil
        index = nil
        days = []
        selectedDate = Date()
    }
    
    func copyAlarmsFromOtherUser(from otherUser: String) {

        FireMethods.get(db: Firestore.firestore(), name: otherUser, documentName: K.FStore.alarmCollection, dataFieldName: K.FStore.alarmCollection, decodeObject: [Alarm].self) { alarms in
            if alarms != [] {
                self.user.alarmData.saveData(alarmArray: alarms)
            }
        }
        
    }
    
}
