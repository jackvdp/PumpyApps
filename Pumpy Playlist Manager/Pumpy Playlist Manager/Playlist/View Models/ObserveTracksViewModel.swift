//
//  ObserveTracksViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/07/2022.
//

import Foundation
import PumpyAnalytics

class ObserveTracksViewModel: ObservableObject {
    
    let playlist: Playlist
    
    init(_ playlist: Playlist) {
        self.playlist = playlist
        let numberOfTracks = playlist.tracks.count
        tracksGettingStats = numberOfTracks
        tracksMatching = playlist.tracks.filter { $0.appleMusicItem == nil }.count
        observeTracks()
    }
    
    @Published var tracksWithStats = 0
    @Published var tracksWithOutStats = 0
    @Published var tracksGettingStats: Int
    
    @Published var tracksMatched = 0
    @Published var tracksNotMatched = 0
    @Published var tracksMatching: Int
    
    private func observeTracks() {
        tracksWithStats = playlist.tracks.filter { $0.audioFeatures != nil }.count
        tracksMatched = playlist.tracks.filter { $0.appleMusicItem != nil }.count
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(changeStats),
                         name: .TracksGotAnalysed,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(changeMatched),
                         name: .TracksMatchedToAppleMusic,
                         object: nil)
    }
    
    @objc func changeStats() {
        tracksWithStats = playlist.tracks.filter { $0.audioFeatures != nil }.count
        tracksWithOutStats = playlist.tracks.filter { $0.audioFeatures == nil && $0.inProgress.analysing == false }.count
        tracksGettingStats = playlist.tracks.filter { $0.inProgress.analysing == true }.count
    }
    
    @objc func changeMatched() {
        tracksMatched = playlist.tracks.filter { $0.appleMusicItem != nil }.count
        tracksNotMatched = playlist.tracks.filter { $0.appleMusicItem == nil && $0.inProgress.gettingAM == false }.count
        tracksMatching = playlist.tracks.filter { $0.inProgress.gettingAM == true }.count
    }
    
    func manualUpdate() {
        changeMatched()
        changeStats()
    }
    
}
