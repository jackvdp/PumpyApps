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
    @Published var currentTrack: ConstructedTrack?
    @Published var currentArtwork: UIImage? = nil
    @Published var playButtonState: PlayButton = .notPlaying
    private let respondDebouncer = Debouncer()
    private let itemDebouncer = Debouncer()
    private let musicPlayerController = MPMusicPlayerController.applicationQueuePlayer
    private let artworkHandler = ArtworkHandler()
    weak var authManager: AuthorisationManager?
    
    init(authManager: AuthorisationManager) {
        self.authManager = authManager
    }
    
    deinit {
        print("deiniting")
        DeinitCounter.count += 1
    }
    
    func updateTrackData() {
        if let nowPlayingItem = musicPlayerController.nowPlayingItem {
            setArtwork(nowPlayingItem)
            currentTrack = ConstructedTrack(title: nowPlayingItem.title,
                                            artist: nowPlayingItem.artist,
                                            artworkURL: nowPlayingItem.artworkURL,
                                            playbackStoreID: nowPlayingItem.playbackStoreID,
                                            isExplicitItem: nowPlayingItem.isExplicitItem)
        } else {
            currentArtwork = nil
            currentTrack = nil
        }
        playButtonState = musicPlayerController.playbackState == .playing ? .playing : .notPlaying
    }
    
    private func setArtwork(_ nowPlayingItem: MPMediaItem) {
        guard let tokenManager = authManager else {
            DispatchQueue.main.async {
                self.currentArtwork = nil
            }
            return
        }
        artworkHandler.getArtwork(from: nowPlayingItem, size: 500, authManager: tokenManager) { image in
//            DispatchQueue.main.async {
//                self.currentArtwork = image
//            }
        }
    }
    
    func updateTrackOnline(for username: String, playlist: String) {
        respondDebouncer.handler = {
            PlaybackData.updatePlaybackInfoOnline(for: username,
                                                  item: self.currentTrack,
                                                  index: self.musicPlayerController.indexOfNowPlayingItem,
                                                  playbackState: self.musicPlayerController.playbackState.rawValue,
                                                  playlistLabel: playlist)
        }
    }
    
}
