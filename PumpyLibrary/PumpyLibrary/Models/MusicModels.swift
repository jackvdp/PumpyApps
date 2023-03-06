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

public protocol Playlist {
    var title: String? { get }
    var artworkURL: String? { get }
    var songs: [Track] { get }
    var cloudGlobalID: String? { get }
}

public protocol Track {
    var name: String { get }
    var artistName: String { get }
    var artworkURL: String? { get }
    var amStoreID: String? { get }
    var isExplicitItem: Bool { get }
}

// MARK: - Constructed

public struct ConstructedPlaylist: Playlist {
    public var title: String?
    public var songs: [Track]
    public var cloudGlobalID: String?
    public var artworkURL: String? = nil
}

public struct ConstructedTrack: Track, Equatable {
    
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

public struct BlockedTrack: Codable, Hashable {
    public init(title: String? = nil,
                artist: String? = nil,
                isExplicit: Bool? = nil,
                playbackID: String) {
        self.title = title
        self.artist = artist
        self.isExplicit = isExplicit
        self.playbackID = playbackID
    }
    
    public var title: String?
    public var artist: String?
    public var isExplicit: Bool?
    public var playbackID: String
}

extension Track {
    public func getBlockedTrack() -> BlockedTrack {
        BlockedTrack(title: name,
                     artist: artistName,
                     isExplicit: isExplicitItem,
                     playbackID: amStoreID ?? "")
    }
}

// MARK: - Extra

public enum PlayButton: String {
    case playing = "Pause"
    case notPlaying = "Play"
}

// MARK: - Extend Anlaytics Models

extension AMPlaylist: PumpyLibrary.Playlist {
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
