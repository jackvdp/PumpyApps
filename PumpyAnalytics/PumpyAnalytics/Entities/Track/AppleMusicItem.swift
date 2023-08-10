//
//  MusicStoreItem.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 24/03/2022.
//

import Foundation

public struct AppleMusicItem: Hashable {
    public var isrc: String
    public var id: String
    public var name: String
    public var artistName: String
    public var artworkURL: String?
    public var genres: [String]
    public var type: MusicStoreType
    
    public var collectiveString: String {
        switch type {
        case .playlist:
            return "playlists"
        case .album:
            return "albums"
        case .station:
            return "stations"
        case .track:
            return "tracks"
        }
    }
}

public enum MusicStoreType: String, Codable {
    case playlist = "playlist"
    case track = "song"
    case album = "album"
    case station = "radioStation"
}

public extension AppleMusicItem {
    /// Used to create a blank item used for converting tracks to AM Library
    public static func blankItemWithID(_ id: String) -> AppleMusicItem {
        AppleMusicItem(isrc: "", id: id, name: "", artistName: "", genres: [], type: .track)
    }
}
