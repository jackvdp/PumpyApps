//
//  TextToPlaylistVM.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 30/10/2022.
//

import Foundation
import PumpyAnalytics
import PumpyShared

class TextToPlaylistViewModel: ObservableObject {
    
    @Published var inputedText = String()
    @Published var tracksDictionary = [(String, Track?)]()
    private var fetcher: FetchTracks?
    private var debouncer = Debouncer()
    
    func convertTextToTracks(authManager: AuthorisationManager) {
        debouncer.handler = { [weak self] in
            guard let self = self else { return }
            let trackStrings = self.seperateBulkTextIntoTrackText(self.inputedText)
            let tracksToFetch = self.prepareDictionaryAndReturnTracksToGet(trackStrings)
            
            self.fetchNewTracks(tracksToFetch, authManager: authManager)
        }
    }
    
    // MARK: Split paragraph into array
    
    func seperateBulkTextIntoTrackText(_ text: String) -> [String] {
        return text
            .split(whereSeparator: \.isNewline)
            .map(String.init)
    }
    
    // MARK: Arrange dictionary
    
    func prepareDictionaryAndReturnTracksToGet(_ trackStrings: [String]) -> [(String, Track?)] {
        let currentKeys = tracksDictionary.map { $0.0 }
        removeKeysNotUsedAnymore(newKeys: trackStrings)
        addNewKeys(newKeys: trackStrings, currentKeys: currentKeys)
        orderDictionary(trackTexts: trackStrings)
        return tracksDictionary.filter { currentKeys.doesNotContain($0.0) && $0.1 == nil }
    }
    
    private func addNewKeys(newKeys: [String], currentKeys: [String]) {
        for key in newKeys {
            if currentKeys.doesNotContain(key) {
                tracksDictionary.append((key, nil))
            }
        }
    }
    
    private func removeKeysNotUsedAnymore(newKeys: [String]) {
        for convertedTrack in tracksDictionary {
            if newKeys.doesNotContain(convertedTrack.0) {
                tracksDictionary.removeAll(where: { $0 == convertedTrack })
            }
        }
    }
    
    func orderDictionary(trackTexts: [String]) {
        tracksDictionary.sort {
            guard let first = trackTexts.firstIndex(of: $0.0) else {
                return false
            }
            
            guard let second = trackTexts.firstIndex(of: $1.0) else {
                return true
            }
            
            return first < second
        }
    }
    
    // MARK: Fetch results
    
    private func fetchNewTracks(_ tracks: [(String, Track?)], authManager: AuthorisationManager) {
        guard let firstTrack = tracks.first else { return }
        fetcher = FetchTracks(tracks: tracks)
        
        fetcher?.fetchNewTrack(firstTrack,
                               authManager: authManager) { [weak self] track in
            
            guard let self = self else { return }
            
            if let index = self.tracksDictionary.firstIndex(where: { $0.0 == track.0}) {
                self.tracksDictionary[index] = track
            }
            
        }
    }
    
    // MARK: Create Playlist
    
    func createPlaylist(authManager: AuthorisationManager) -> TrackPlaylist {
        let tracks = tracksDictionary.compactMap { $0.1 }
        return TrackPlaylist(name: "Text to Playlist",
                             curator: "",
                             tracks: tracks, artworkURL: nil,
                             description: nil,
                             shortDescription: nil,
                             authManager: authManager,
                             sourceID: UUID().uuidString)
    }
    
}
