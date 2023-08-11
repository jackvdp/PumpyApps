//
//  AMAlbum.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/09/2022.
//

import Foundation

public class AMAlbum: Playlist {
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
    
    public func getTracksData() {
        GetAudioFeaturesAndSpotifyItem().forPlaylist(tracks: tracks, authManager: authManager)
    }
    
    public func removeDuplicates() {
        //
    }
    
}

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
    
    public func getTracksData() {
        GetAudioFeaturesAndSpotifyItem().forPlaylist(tracks: tracks, authManager: authManager)
    }
    
    public func removeDuplicates() {
        //
    }
    
}
