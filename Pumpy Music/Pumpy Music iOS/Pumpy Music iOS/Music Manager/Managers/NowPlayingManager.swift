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
import Kingfisher

class NowPlayingManager: NowPlayingProtocol {
    @Published var currentTrack: PumpyLibrary.Track? {
        didSet {
            guard let currentTrack, let authManager else { currentAnalyticsTrack = nil; return }
            currentAnalyticsTrack = currentTrack.analyticsTrack(authManager: authManager)
        }
    }
    @Published var currentArtwork: UIImage?
    var currentAnalyticsTrack: PumpyAnalytics.Track?
    @Published var playButtonState: PlayButton = .notPlaying
    private let respondDebouncer = Debouncer()
    private let itemDebouncer = Throttle(minimumDelay: 0.5)
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
        fetchArtwork()
        playButtonState = musicPlayerController.playbackState == .playing ? .playing : .notPlaying
    }
    
    func updateTrackOnline(for username: Username, playlist: String) {
        respondDebouncer.handle() { [weak self] in
            
            guard let self, let currentTrack = currentTrack else { return }
            
            let queueTrack = QueueTrack(
                title: currentTrack.name,
                artist: currentTrack.artistName,
                artworkURL: currentTrack.artworkURL,
                playbackStoreID: currentTrack.amStoreID ?? "",
                isExplicitItem: currentTrack.isExplicitItem
            )
            
            PlaybackData
                .shared
                .updatePlaybackInfoOnline(
                    for: username,
                    item: queueTrack,
                    index: musicPlayerController.indexOfNowPlayingItem,
                    playbackState: musicPlayerController.playbackState.rawValue,
                    playlistLabel: playlist
                )
        }
    }
    
    func fetchArtwork() {
        currentArtwork = musicPlayerController.nowPlayingItem?.artwork?.image(at: CGSize(width: 400, height: 400))
        if currentArtwork == nil, let urlString = musicPlayerController.nowPlayingItem?.artworkURL, let url = URL(string: urlString)  {
            KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    currentArtwork = value.image
                    BackgroundColourHandler.shared.setColour(fromImage: self.currentArtwork)
                    objectWillChange.send()
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
        BackgroundColourHandler.shared.setColour(fromImage: currentArtwork)
    }
}
