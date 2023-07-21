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
import PumpyAnalytics

class User: ObservableObject, UserProtocol {
    
    typealias M = MusicManager
    typealias P = PlaylistManager
    
    let username: Username
    weak var remoteManager: RemoteManager?
    weak var alarmManager: AlarmManager?
    weak var settingsManager: SettingsManager?
    weak var externalDisplayManager: ExternalDisplayManager<PlaylistManager>?
    weak var musicManager: MusicManager?
    weak var authManager: AuthorisationManager?
    weak var blockedTracksManager: BlockedTracksManager?
    weak var playlistManager: PlaylistManager?
    
    init(username: Username) {
        self.username = username
        PlaybackData.shared.savePlaylistsOnline(for: username)
        ActiveInfo.save(.loggedIn, for: username)
    }
    
    deinit {
        print("Deinit user")
    }
    
    func setUp(alarmManager: AlarmManager,
               remoteManager: RemoteManager,
               externalDisplayManager: ExternalDisplayManager<PlaylistManager>,
               musicManager: MusicManager,
               authManager: AuthorisationManager,
               blockedTracksMamager: BlockedTracksManager,
               playlistManager: PlaylistManager) {
        self.alarmManager = alarmManager
        self.remoteManager = remoteManager
        self.externalDisplayManager = externalDisplayManager
        self.musicManager = musicManager
        self.authManager = authManager
        self.blockedTracksManager = blockedTracksMamager
        self.playlistManager = playlistManager
    }
    
    func signOut() {
        FirebaseStore.shared.signOut()
        ActiveInfo.save(.loggedOut, for: username)
        alarmManager?.removeObservers()
        remoteManager?.removeListener()
        blockedTracksManager?.removeListener()
        playlistManager?.scheduleManager.removeObservers()
        authManager?.removeTimer()
        musicManager?.endNotifications()
        settingsManager?.removeSettingsListener()
        externalDisplayManager?.removeSettingsListener()
        playlistManager?.scheduleManager.removeObservers()
    }
}
