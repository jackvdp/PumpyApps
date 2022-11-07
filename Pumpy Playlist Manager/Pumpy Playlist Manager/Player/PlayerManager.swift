//
//  NewPlayerManager.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/06/2022.
//

import Foundation
import AVFoundation
import PumpyAnalytics

class PlayerManager: ObservableObject {
    
    @Published var player: AVQueuePlayer?
    @Published var playlistPlaying: String?
    @Published var playerState: PlayerState = .notPlaying
    @Published var currentTrack: Track?
    private var queue = [Track]()
    private var timer: Timer?
    private var incrementTimeSlide: CGFloat = 0
    @Published var currentTime: CGFloat = 0
    
    init() {
        subscribeToNotifications()
    }
    
    deinit {
        removeObserver()
    }
    
    func playNow(_ trks: [Track]) {
        guard let player = player else {
            playQueue(trks, from: nil)
            return
        }
        
        let items = player.items()
        playQueue(trks, from: nil, items: items)
        
    }
    
    func playNext(_ trks: [Track]) {
        guard player != nil else {
            playQueue(trks, from: nil)
            return
        }
        playlistPlaying = nil
        addTracksToQueue(trks.reversed(), from: playlistPlaying, prepend: true)
    }
    
    func playQueue(_ trks: [Track], from playlistName: String?, items: [AVPlayerItem] = []) {
        var tracks = trks.filter { $0.previewUrl != nil }
        guard tracks.count > 0 else { return }
        
        queue = tracks
        playlistPlaying = playlistName
        
        let firstItem = tracks.removeFirst()
        if let url = URL(string: firstItem.previewUrl!) {
            let item = AVPlayerItem(url: url)
            player = AVQueuePlayer(playerItem: item)
            player?.play()
            
            addTracksToQueue(tracks, from: playlistName, items: items)
            
        } else {
            playQueue(tracks, from: playlistName)
        }
    }
    
    private func addTracksToQueue(_ tracks: [Track], from playlistName: String?, prepend: Bool = false, items: [AVPlayerItem] = []) {
        guard tracks.count > 0 else { return }
        let strings = tracks.compactMap { $0.previewUrl }
        let urls = strings.compactMap { URL(string: $0)}
        makeAssetsAddToQueue(urls: urls, from: playlistName, prepend: prepend, items: items)
    }
    
    private func makeAssetsAddToQueue(urls: [URL], from playlistName: String?, prepend: Bool = false, items: [AVPlayerItem] = []) {
        guard urls.count > 0 else { return }
        var variableURLs = urls
        let url = variableURLs.removeFirst()
        let asset = AVAsset(url: url)
        let assetKeys = ["playable"]
        
        asset.loadValuesAsynchronously(forKeys: assetKeys) {
            if playlistName == self.playlistPlaying {
                let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
                if prepend {
                    self.player?.insert(item, after: self.player?.currentItem)
                } else {
                    self.player?.insert(item, after: nil)
                }
                if !variableURLs.isEmpty {
                    self.makeAssetsAddToQueue(urls: variableURLs, from: playlistName, prepend: prepend, items: items)
                } else {
                    self.addItemsToQueue(items: items)
                }
            }
        }
    }
    
    private func addItemsToQueue(items: [AVPlayerItem]) {
        for item in items {
            self.player?.insert(item, after: nil)
        }
    }
    
    // MARK: - Controls

    func playPauseMusic() {
        player?.isPlaying ?? false ? player?.pause() : player?.play()
    }
    
    func nextTrack() {
        player?.advanceToNextItem()
    }
    
    func quitPlayer() {
        player = nil
        queue = []
        currentTrack = nil
        currentTime = 0
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Notoification & UI Update
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEndTrack),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changePlayState),
                                               name: AVPlayer.rateDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSkipTrack),
                                               name: AVPlayerItem.timeJumpedNotification,
                                               object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: AVPlayer.rateDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AVPlayerItem.timeJumpedNotification, object: nil)
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func didEndTrack() {
        setCurrentPlayingInfo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setCurrentPlayingInfo()
        }
    }
    
    @objc private func didSkipTrack() {
        setCurrentPlayingInfo()
    }
    
    @objc private func changePlayState() {
        if player?.isPlaying ?? false {
            playerState = .playing
            setUpTimer()
        } else {
            playerState = .notPlaying
            timer?.invalidate()
            timer = nil
        }
        getTime()
    }
    
    
    private func setCurrentPlayingInfo() {
        if let url = (player?.currentItem?.asset as? AVURLAsset)?.url {
            currentTrack = queue.first(where: { track in
                track.previewUrl ?? "" == url.absoluteString
            })
        }
        getTime()
    }
    
    private func setUpTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.getTime()
        }
    }
    
    private func getTime() {
        if let item = player?.currentItem {
            let duration = item.asset.duration.seconds
            let time = item.currentTime().seconds
            
            let timePercentage = time / duration
            if timePercentage < 0 || timePercentage > 1 {
                currentTime = 1
            } else {
                currentTime = timePercentage
            }
        } else {
            currentTime = 0
            currentTrack = nil
            playerState = .notPlaying
            timer?.invalidate()
            timer = nil
        }
    }
}
