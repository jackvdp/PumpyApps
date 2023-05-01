//
//  CurrentItemManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 13/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import PumpyLibrary
import PumpyAnalytics
import PumpyShared

class NowPlayingManager: NowPlayingProtocol {
    @Published var currentTrack: QueueTrack?
    @Published var playButtonState: PlayButton = .notPlaying
    private let respondDebouncer = Debouncer()
    private let itemDebouncer = Debouncer()
    private let musicPlayerController = MPMusicPlayerController.applicationQueuePlayer
    private let artworkHandler = ArtworkHandler()
    weak var authManager: AuthorisationManager?
    
    func setUp(authManager: AuthorisationManager) {
        self.authManager = authManager
    }
    
    deinit {
        print("deiniting NPM")
    }
    
    func updateTrackData() {
        if let nowPlayingItem = musicPlayerController.nowPlayingItem {
            currentTrack = QueueTrack(title: nowPlayingItem.name,
                                            artist: nowPlayingItem.artistName,
                                            artworkURL: nowPlayingItem.artworkURL,
                                            playbackStoreID: nowPlayingItem.playbackStoreID,
                                            isExplicitItem: nowPlayingItem.isExplicitItem)
        } else {
            currentTrack = nil
        }
        playButtonState = musicPlayerController.playbackState == .playing ? .playing : .notPlaying
    }
    
    func updateTrackOnline(for username: String, playlist: String) {
        respondDebouncer.handle() { [weak self] in
            guard let self else { return }
            PlaybackData
                .shared
                .updatePlaybackInfoOnline(for: username,
                                          item: self.currentTrack,
                                          index: self.musicPlayerController.indexOfNowPlayingItem,
                                          playbackState: self.musicPlayerController.playbackState.rawValue,
                                          playlistLabel: playlist)
        }
    }
    
}
