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
        alarmData.setUp()
        remoteDataManager = RemoteManager(username: username, musicManager: musicManager, alarmManager: alarmData)
        externalDisplayManager = ExternalDisplayManager(username: username, playlistManager: musicManager.playlistManager)
        PlaybackData.savePlaylistsOnline(for: username)
        ActiveInfo.save(.loggedIn, for: username)
    }
    
    deinit {
        print("Deinit")
    }
    
    func signOut() {
        firebaseSignOut()
        ActiveInfo.save(.loggedOut, for: username)
        alarmData.removeObservers()
        remoteDataManager.removeListener()
        musicManager.blockedTracksManager.removeListener()
        musicManager.playlistManager.scheduleManager.removeObservers()
        musicManager.authManager.removeTimer()
        musicManager.endNotifications()
        settingsManager.removeSettingsListener()
        externalDisplayManager.removeSettingsListener()
        print(CFGetRetainCount(musicManager))
        print(CFGetRetainCount(musicManager.authManager))
        print(CFGetRetainCount(musicManager.blockedTracksManager))
        print(CFGetRetainCount(musicManager.playlistManager))
        print(CFGetRetainCount(musicManager.queueManager))
        print(CFGetRetainCount(settingsManager))
        
    }
    
    func firebaseSignOut() {
        FirebaseStore.shared.signOut()
    }
    
}
