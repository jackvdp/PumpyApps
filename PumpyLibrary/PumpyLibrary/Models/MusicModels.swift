//
//  MusicModels.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/08/2022.
//

import Foundation
import MediaPlayer
import MusicKit
import PumpyAnalytics

// MARK: - Protocols

public protocol MusicCollection {
    var artworkURL: String? { get }
}

public protocol Playlist: MusicCollection, ScheduledPlaylist {
    var title: String? { get }
    var artworkURL: String? { get }
    var songs: [Track] { get }
    var cloudGlobalID: String? { get }
    var shortDescription: String? { get }
    var longDescription: String? { get }
}

public protocol Track: MusicCollection {
    var name: String { get }
    var artistName: String { get }
    var artworkURL: String? { get }
    var amStoreID: String? { get }
    var isExplicitItem: Bool { get }
}

// MARK: - Queue

/// Used to put a custom array (normally a subset of a playlist) of tracks into the queue
public struct QueuePlaylist: Playlist {
    public var title: String?
    public var songs: [Track]
    public var cloudGlobalID: String?
    public var artworkURL: String? = nil
    public var shortDescription: String?
    public var longDescription: String?
    
    public var name: String? { title }
}

/// Used as an interface for dealing with queue tracks i.e. by NowPlayingManager/QueueManager/UpNextList
public struct QueueTrack: Track, Equatable {
    
    public init(title: String = "",
                artist: String = "",
                artworkURL: String? = nil,
                playbackStoreID: String,
                isExplicitItem: Bool) {
        self.name = title
        self.artistName = artist
        self.artworkURL = artworkURL
        self.amStoreID = playbackStoreID
        self.isExplicitItem = isExplicitItem
    }
    
    public var name: String
    public var artistName: String
    public var artworkURL: String?
    public var amStoreID: String?
    public var isExplicitItem: Bool
}

// MARK: - Blocked

public struct CodableTrack: Codable, Hashable, MusicCollection {
    public init(title: String,
                artist: String,
                isExplicit: Bool,
                artworkURL: String?,
                playbackID: String) {
        self.title = title
        self.artist = artist
        self.isExplicit = isExplicit
        self.artworkURL = artworkURL
        self.playbackID = playbackID
    }
    
    public var title: String
    public var artist: String
    public var isExplicit: Bool
    public var artworkURL: String?
    public var playbackID: String
}

extension Track {
    public func getBlockedTrack() -> CodableTrack? {
        guard let amStoreID else { return nil }
        return CodableTrack(title: name,
                            artist: artistName,
                            isExplicit: isExplicitItem,
                            artworkURL: artworkURL,
                            playbackID: amStoreID)
    }
}

// MARK: - Extra

public enum PlayButton: String {
    case playing = "Pause"
    case notPlaying = "Play"
}

// MARK: - Extend Anlaytics Models

extension AMPlaylist: PumpyLibrary.Playlist {
    public var longDescription: String? {
        self.description
    }
    
    public var title: String? {
        self.name
    }
    
    public var songs: [Track] {
        self.tracks
    }

    public var cloudGlobalID: String? {
        self.sourceID
    }
}

extension SpotifyPlaylist: PumpyLibrary.Playlist {
    public var longDescription: String? {
        self.description
    }
    public var title: String? {
        self.name
    }
    
    public var songs: [Track] {
        self.tracks
    }

    public var cloudGlobalID: String? {
        nil
    }
}

extension SYBPlaylist: PumpyLibrary.Playlist {
    public var longDescription: String? {
        self.description
    }
    public var title: String? {
        self.name
    }
    
    public var songs: [Track] {
        self.tracks
    }

    public var cloudGlobalID: String? {
        nil
    }
}

extension RecommendedPlaylist: PumpyLibrary.Playlist {
    public var longDescription: String? {
        self.description
    }
    public var title: String? {
        self.name
    }
    
    public var songs: [Track] {
        self.tracks
    }

    public var cloudGlobalID: String? {
        nil
    }
}

extension PumpyAnalytics.Track: Track {
    public var name: String {
        self.title
    }
    
    public var artistName: String {
        self.artist
    }
    
    public var amStoreID: String? {
        self.appleMusicItem?.id
    }
    
    public var isExplicitItem: Bool {
        self.isExplicit
    }
}
