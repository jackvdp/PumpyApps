//
//  User.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 28/06/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import UserNotifications
import PumpyLibrary

class User: ObservableObject, UserProtocol {
    
    typealias M = MusicManager
    typealias P = PlaylistManager
    
    let username: String
    let remoteDataManager: RemoteManager
    let alarmData: AlarmManager
    let settingsManager: SettingsManager
    let externalDisplayManager: ExternalDisplayManager<PlaylistManager>
    let musicManager: MusicManager
    
    init(username: String) {
        self.username = username
        settingsManager = SettingsManager(username: username)
        musicManager = MusicManager(username: username, settingsManager: settingsManager)
        alarmData = AlarmManager(username: username)
        remoteDataManager = RemoteManager(username: username, musicManager: musicManager, alarmManager: alarmData)
        externalDisplayManager = ExternalDisplayManager(username: username, playlistManager: musicManager.playlistManager)
        PlaybackData.savePlaylistsOnline(for: username)
        ActiveInfo.save(.loggedIn, for: username)
    }
    
    deinit {
        DeinitCounter.count += 1
    }
    
    func signOut() {
        firebaseSignOut()
        ActiveInfo.save(.loggedOut, for: username)
        alarmData.removeObservers()
        remoteDataManager.removeListener()
        musicManager.blockedTracksManager.removeListener()
        musicManager.playlistManager.scheduleManager.removeObservers()
        musicManager.endNotifications()
        settingsManager.removeSettingsListener()
        externalDisplayManager.removeSettingsListener()
    }
    
    func firebaseSignOut() {
        FirebaseStore.shared.signOut()
    }
    
}

struct DeinitCounter {
    static var count = 0 {
        didSet {
            print("*****  " + count.description)
        }
    }
}
