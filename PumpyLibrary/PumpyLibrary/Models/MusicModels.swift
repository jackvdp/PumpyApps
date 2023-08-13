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
    var curator: String { get }
    var artworkURL: String? { get }
    var songs: [Track] { get }
    var cloudGlobalID: String? { get }
    var shortDescription: String? { get }
    var longDescription: String? { get }
    var type: PlaylistType { get }
    var sourceID: String { get }
}

extension Playlist {
    func snaposhot() -> PlaylistSnapshot {
        PlaylistSnapshot(
            name: title,
            curator: curator,
            artworkURL: artworkURL,
            shortDescription: shortDescription,
            sourceID: sourceID,
            type: type
        )
    }
}

public protocol Track: MusicCollection {
    var name: String { get }
    var artistName: String { get }
    var artworkURL: String? { get }
    var amStoreID: String? { get }
    var isExplicitItem: Bool { get }
    
    func analyticsTrack(authManager: AuthorisationManager) -> PumpyAnalytics.Track
}

// MARK: - Queue

/// Used to put a custom array (normally a subset of a playlist) of tracks into the queue
public struct QueuePlaylist: Playlist {
    public var title: String?
    public var curator: String
    public var songs: [Track]
    public var cloudGlobalID: String?
    public var artworkURL: String? = nil
    public var shortDescription: String?
    public var longDescription: String?
    
    public var name: String? { title }
    public var sourceID: String { cloudGlobalID ?? "" }
    public var type: PlaylistType { .am(id: cloudGlobalID ?? "") }
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
        self.playbackStoreID = playbackStoreID
        self.isExplicitItem = isExplicitItem
    }
    
    public var name: String
    public var artistName: String
    public var artworkURL: String?
    public var amStoreID: String?
    public var playbackStoreID: String
    public var isExplicitItem: Bool
    
    public func analyticsTrack(authManager: AuthorisationManager) -> PumpyAnalytics.Track {
        PumpyAnalytics.Track(title: name, artist: artistName, album: "", isrc: nil, artworkURL: artworkURL, previewUrl: nil, isExplicit: isExplicitItem, sourceID: playbackStoreID, authManager: authManager)
    }
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

extension CodableTrack: PumpyLibrary.Track {
    
    public var name: String { title }
    
    public var artistName: String { artist }
    
    public var amStoreID: String? { playbackID }
    
    public var isExplicitItem: Bool { isExplicit }
    
    public func analyticsTrack(authManager: AuthorisationManager) -> PumpyAnalytics.Track {
        PumpyAnalytics.Track(title: name, artist: artistName, album: "", isrc: nil, artworkURL: artworkURL, previewUrl: nil, isExplicit: isExplicitItem, sourceID: playbackID, authManager: authManager)
    }
}

extension Track {
    public func codableTrack() -> CodableTrack? {
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
    
    public var type: PumpyAnalytics.PlaylistType {
        .am(id: sourceID)
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
    
    public var type: PumpyAnalytics.PlaylistType {
        .spotify(id: sourceID)
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
    
    public var type: PumpyAnalytics.PlaylistType {
        .syb(id: sourceID)
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
    
    public var type: PumpyAnalytics.PlaylistType {
        .recommended(tracks.compactMap { $0.spotifyItem?.id })
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
    
    public func analyticsTrack(authManager: PumpyAnalytics.AuthorisationManager) -> PumpyAnalytics.Track {
        return self
    }
}

extension AMAlbum: PumpyLibrary.Playlist {
    public var title: String? {
        name
    }
    
    public var songs: [Track] {
        tracks
    }
    
    public var cloudGlobalID: String? {
        sourceID
    }
    
    public var longDescription: String? {
        description
    }
    
    public var type: PumpyAnalytics.PlaylistType {
        .am(id: sourceID)
    }
}

extension AMStation: PumpyLibrary.Playlist {
    public var title: String? {
        name
    }
    
    public var songs: [Track] {
        tracks
    }
    
    public var cloudGlobalID: String? {
        sourceID
    }
    
    public var longDescription: String? {
        description
    }
    
    public var type: PumpyAnalytics.PlaylistType {
        .am(id: sourceID)
    }
}
