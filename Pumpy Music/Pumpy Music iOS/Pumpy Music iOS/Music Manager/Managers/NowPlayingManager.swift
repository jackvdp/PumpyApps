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
    @Published var currentTrack: PumpyLibrary.Track? {
        didSet {
            guard let currentTrack, let authManager else { currentAnalyticsTrack = nil; return }
            currentAnalyticsTrack = currentTrack.analyticsTrack(authManager: authManager)
        }
    }
    var currentAnalyticsTrack: PumpyAnalytics.Track?
    @Published var playButtonState: PlayButton = .notPlaying
    private let respondDebouncer = Debouncer()
    private let itemDebouncer = Debouncer()
    private let musicPlayerController = MPMusicPlayerController.applicationQueuePlayer
    weak var authManager: AuthorisationManager?
    
    func setUp(authManager: AuthorisationManager) {
        self.authManager = authManager
    }
    
    deinit {
        print("deiniting NPM")
    }
    
    func updateTrackData() {
        currentTrack = musicPlayerController.nowPlayingItem
        playButtonState = musicPlayerController.playbackState == .playing ? .playing : .notPlaying
    }
    
    func updateTrackOnline(for username: Username, playlist: String) {
        respondDebouncer.handle() { [weak self] in
            
            guard let self,
                  let currentTrack = self.currentTrack else { return }
            
            let queueTrack = QueueTrack(title: currentTrack.name,
                                        artist: currentTrack.artistName,
                                        artworkURL: currentTrack.artworkURL,
                                        playbackStoreID: currentTrack.amStoreID ?? "",
                                        isExplicitItem: currentTrack.isExplicitItem)
            PlaybackData
                .shared
                .updatePlaybackInfoOnline(for: username,
                                          item: queueTrack,
                                          index: self.musicPlayerController.indexOfNowPlayingItem,
                                          playbackState: self.musicPlayerController.playbackState.rawValue,
                                          playlistLabel: playlist)
        }
    }
    
}
