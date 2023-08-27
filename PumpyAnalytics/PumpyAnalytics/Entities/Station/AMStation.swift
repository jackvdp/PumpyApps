//
//  AMStation.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 14/08/2023.
//

import Foundation

public class AMStation: Playlist {
    public var name: String?
    public var curator: String
    public var tracks: [Track]
    public var artworkURL: String?
    public var description: String?
    public var shortDescription: String?
    public var sourceID: String
    public var authManager: AuthorisationManager
    public var uuid = UUID()
    public var snapshot: PlaylistSnapshot
    
    private lazy var getAudioFeaturesUseCase = GetAudioFeaturesAndSpotifyItem()
    
    public init(name: String? = nil, curator: String, tracks: [Track], artworkURL: String? = nil, description: String? = nil, shortDescription: String? = nil, sourceID: String, authManager: AuthorisationManager) {
        self.name = name
        self.curator = curator
        self.tracks = tracks
        self.artworkURL = artworkURL
        self.description = description
        self.shortDescription = shortDescription
        self.sourceID = sourceID
        self.authManager = authManager
        // Needs to be developed to properly support album
        self.snapshot = .init(sourceID: sourceID, type: .am(id: sourceID))
    }
    
    private var feautresTask: Task<(), Never>?
    
    public func getTracksData() {
        feautresTask = Task {
            await getAudioFeaturesUseCase.forPlaylist(tracks: tracks, authManager: authManager)
        }
    }
    
    public func matchToAM() {}
    
    public func removeDuplicates() {}
    
    public func cancelTasks() {
        feautresTask?.cancel()
        feautresTask = nil
    }
    
}
