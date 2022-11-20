//
//  MusicModels.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/08/2022.
//

import Foundation
import MediaPlayer
import MusicKit

public protocol Track {
    var title: String? { get }
    var artist: String? { get }
    var artworkURL: String? { get }
    var playbackStoreID: String { get }
    var isExplicitItem: Bool { get }
    func getBlockedTrack() -> BlockedTrack
}

public protocol Playlist {
    var name: String? { get }
    var artworkURL: String? { get }
    var tracks: [Track] { get }
    var cloudGlobalID: String? { get }
}

public struct BlockedTrack: Codable, Hashable {
    public init(title: String? = nil, artist: String? = nil, isExplicit: Bool? = nil, playbackID: String) {
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

public enum PlayButton: String {
    case playing = "Pause"
    case notPlaying = "Play"
}

public struct ConstructedPlaylist: Playlist {
    public var name: String?
    
    public var tracks: [Track]
    
    public var cloudGlobalID: String?
    
    public var artworkURL: String? = nil
    
}

public struct ConstructedTrack: Track, Equatable {
    public init(title: String? = nil, artist: String? = nil, artworkURL: String? = nil, playbackStoreID: String, isExplicitItem: Bool) {
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        self.playbackStoreID = playbackStoreID
        self.isExplicitItem = isExplicitItem
    }
    
    public var title: String?
    
    public var artist: String?
    
    public var artworkURL: String?
    
    public var playbackStoreID: String
    
    public var isExplicitItem: Bool
    
    public func getBlockedTrack() -> BlockedTrack {
        BlockedTrack(title: title, artist: artist, isExplicit: isExplicitItem, playbackID: playbackStoreID)
    }
    
}
