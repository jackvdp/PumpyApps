//
//  SetScheduleViewModel.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 31/08/2022.
//

import Foundation

class SetScheduleViewModel: ObservableObject {
    
    weak var alarmData: AlarmManager?
    var getPlaylists: () -> [ScheduledPlaylist]
    let alarm: Alarm?
    
    @Published var playlists = [String]()
    @Published var selectedDate = Date()
    @Published var playlistIndex: Int?
    @Published var days = [DetailInfo.DaysOfWeek]()
    @Published var secondaryPlaylists = [SecondaryPlaylist]()
    
    // External Display Settings
    @Published var externalSettingsOverride = false
    @Published var showQRCode: Bool = false
    @Published var qrLink = String()
    @Published var qrMessage = String()
    @Published var contentType: ExtDisContentType = .artworkAndTitles
    @Published var messageSpeed: Double = 8.0
    @Published var qrType: QRType = .playlist
    
    init(alarm: Alarm?, alarmManager: AlarmManager, getPlists: @escaping () -> [ScheduledPlaylist]) {
        self.alarmData = alarmManager
        self.getPlaylists = getPlists
        self.alarm = alarm
        loadPlaylists()
        setAlarm()
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
        if let a = alarm {
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
        guard let i = playlistIndex else { return }
        let newAlarm = createNewAlarm(playlistIndex: i)
        
        if alarm == nil {
            alarmData?.addAlarm(alarm: newAlarm)
        } else {
            alarmData?.updateAlarm(alarm: newAlarm)
        }
    }
    
    func createNewAlarm(playlistIndex i: Int) -> Alarm {
        if externalSettingsOverride {
            return Alarm(uuid: alarm?.uuid ?? UUID().uuidString,
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
            return Alarm(uuid: alarm?.uuid ?? UUID().uuidString,
                         time: Time(hour: selectedDate.hour, min: selectedDate.minute),
                         playlistLabel: playlists[i],
                         repeatStatus: days,
                         secondaryPlaylists: secondaryPlaylists)
        }
    }
}
