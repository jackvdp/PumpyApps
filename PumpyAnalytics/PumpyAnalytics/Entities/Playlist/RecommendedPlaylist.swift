//
//  RecommendedPlaylist.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 20/06/2022.
//

import Foundation

public class RecommendedPlaylist: Playlist {
    
    public init(name: String? = nil, tracks: [Track], artworkURL: String? = nil, description: String? = nil, shortDescription: String? = nil, authManager: AuthorisationManager, sourceID: String) {
        self.name = name
        self.curator = "Pumpy AI"
        self.tracks = tracks
        self.artworkURL = artworkURL
        self.description = description
        self.shortDescription = shortDescription
        self.authManager = authManager
        self.sourceID = sourceID
        removeDuplicates()
    }

    public var name: String?
    public var curator: String
    public var tracks: [Track]
    public var artworkURL: String?
    public var description: String?
    public var shortDescription: String?
    public var authManager: AuthorisationManager
    public var sourceID: String
    public var uuid: UUID = UUID()
    
    public var snapshot: PlaylistSnapshot {
        PlaylistSnapshot(
            name: name,
            sourceID: sourceID,
            type: .recommended(getTrackIDs(tracks))
        )
    }
    
    public func getTracksData() {
        GetAudioFeaturesAndSpotifyItem().forPlaylist(tracks: tracks, authManager: authManager)
        MatchToAM().execute(tracks: tracks, authManager: authManager)
    }
    
    public func removeDuplicates() {
        tracks = tracks.removingDuplicates()
    }
    
    private func getTrackIDs(_ trks: [Track]) -> [String] {
        trks.compactMap { $0.spotifyItem?.id }
    }
    
}
