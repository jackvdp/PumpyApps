//
//  TrackModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 25/02/2022.
//

import Foundation

public class Track: Identifiable, Hashable, ObservableObject {
    
    public var title: String
    public var artist: String
    public var album: String?
    public var isrc: String?
    public var artworkURL: String?
    public var previewUrl: String?
    public var isExplicit: Bool
    public var sourceID: String
    public var id = UUID()
    public var authManager: AuthorisationManager
    @Published public var inProgress = InProgress()
    
    @Published public var spotifyItem: SpotifyItem? {
        didSet { inProgress.gettingSpotify = false }
    }
    @Published public var appleMusicItem: AppleMusicItem? {
        didSet { inProgress.gettingAM = false }
    }
    @Published public var audioFeatures: AudioFeatures? {
        didSet { inProgress.analysing = false }
    }
    
    public init(title: String, artist: String, album: String, isrc: String?, artworkURL: String?, previewUrl: String?, isExplicit: Bool, sourceID: String, authManager: AuthorisationManager, appleMusicItem: AppleMusicItem? = nil, spotifyItem: SpotifyItem? = nil) {
        self.title = title
        self.artist = artist
        self.album = album
        self.isrc = isrc
        self.artworkURL = artworkURL
        self.previewUrl = previewUrl
        self.isExplicit = isExplicit
        self.sourceID = sourceID
        self.authManager = authManager
        self.appleMusicItem = appleMusicItem
        self.spotifyItem = spotifyItem
    }
    
}

extension Track {
    
    public static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.sourceID == rhs.sourceID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sourceID)
    }
        
    public struct InProgress {
        public var analysing = false
        public var gettingSpotify = false
        public var gettingAM = false
    }
}
