//
//  UpNextManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 19/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import PumpyLibrary
import PumpyAnalytics

class MusicManager: ObservableObject, MusicProtocol {
    let musicPlayerController = MPMusicPlayerController.applicationQueuePlayer
    var username: String?
    weak var nowPlayingManager: NowPlayingManager?
    weak var playlistManager: PlaylistManager?
    weak var queueManager: QueueManager?
    weak var blockedTracksManager: BlockedTracksManager?
    weak var settingsManager: SettingsManager?
    weak var authManager: AuthorisationManager?
    weak var remoteManager: RemoteManager?
    
    init() {
        setUpNotifications()
    }
    
    deinit {
        print("deiniting MM")
        endNotifications()
    }
    
    func setUp(nowPlayingManager: NowPlayingManager,
                         playlistManager: PlaylistManager,
                         queueManager: QueueManager,
                         blockedTracksManager: BlockedTracksManager,
                         settingsManager: SettingsManager,
                         authManager: AuthorisationManager,
                         username: String, remoteManager: RemoteManager) {
        self.nowPlayingManager = nowPlayingManager
        self.playlistManager = playlistManager
        self.queueManager = queueManager
        self.blockedTracksManager = blockedTracksManager
        self.settingsManager = settingsManager
        self.authManager = authManager
        self.username = username
        self.remoteManager = remoteManager
    }
    
    // MARK: - Setup Notifications
    
    func setUpNotifications() {
        musicPlayerController.beginGeneratingPlaybackNotifications()
        addMusicObserver(for: .MPMusicPlayerControllerNowPlayingItemDidChange,
                         action: #selector(handleMusicPlayerManagerDidUpdateState))
        addMusicObserver(for: .MPMusicPlayerControllerPlaybackStateDidChange,
                         action: #selector(handleMusicPlayerManagerDidUpdateState))
        addMusicObserver(for: .MPMusicPlayerControllerQueueDidChange,
                         action: #selector(handleQueueDidUpdateState))
        addMusicObserver(for: .MPMediaLibraryDidChange,
                         action: #selector(handleLibraryDidChangeState))
    }
    
    func endNotifications() {
        removeMusicObservers(for: [
            .MPMusicPlayerControllerNowPlayingItemDidChange,
            .MPMusicPlayerControllerPlaybackStateDidChange,
            .MPMusicPlayerControllerQueueDidChange,
            .MPMediaLibraryDidChange
        ])
        musicPlayerController.endGeneratingPlaybackNotifications()
    }
    
    // MARK: - Respond to Notifications
    
    @objc func handleMusicPlayerManagerDidUpdateState(_ notification: Notification) {
        queueManager?.getIndex()
        nowPlayingManager?.updateTrackData()
        if let playlistManager, let username {
            nowPlayingManager?.updateTrackOnline(for: username,
                                                 playlist: playlistManager.playlistLabel)
        }
    }
    
    @objc func handleQueueDidUpdateState(_ notification: Notification) {
        queueManager?.getUpNext()
    }
    
    @objc func handleLibraryDidChangeState(_ notification: Notification) {
        if let username {
            PlaybackData.shared.savePlaylistsOnline(for: username)
        }
    }
    
}
