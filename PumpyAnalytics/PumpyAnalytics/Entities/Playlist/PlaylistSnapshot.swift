//
//  LibraryPlaylist.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 24/05/2022.
//

import Foundation

public struct PlaylistSnapshot: Codable, Hashable {
    public init(name: String? = nil, curator: String? = nil, artworkURL: String? = nil, shortDescription: String? = nil, sourceID: String, type: PlaylistType) {
        self.name = name
        self.curator = curator
        self.artworkURL = artworkURL
        self.shortDescription = shortDescription
        self.sourceID = sourceID
        self.type = type
    }
    
    public var name: String?
    public var curator: String?
    public var artworkURL: String?
    public var shortDescription: String?
    public var sourceID: String
    public var type: PlaylistType

}

extension PlaylistSnapshot {
    
    public static func == (lhs: PlaylistSnapshot, rhs: PlaylistSnapshot) -> Bool {
        return lhs.sourceID == rhs.sourceID &&
        lhs.name == rhs.name &&
        lhs.artworkURL == rhs.artworkURL &&
        lhs.shortDescription == rhs.shortDescription &&
        lhs.sourceID == rhs.sourceID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sourceID)
    }
    
}

public enum PlaylistType: Codable, Equatable {
    case syb(id: String)
    case am(id: String)
    case spotify(id: String)
    case custom(CustomPlaylistLogic)
    case text
    case recommended(_ spotifyTrackIDs: [String])
    
    public static func == (lhs: PlaylistType, rhs: PlaylistType) -> Bool {
        switch (lhs, rhs) {
        case (.syb(let p), .syb(let x)): return p == x
        case (.am(let p), .am(let x)): return p == x
        case (.spotify(let p), .spotify(let x)): return p == x
        case (.custom, .custom): return true
        case (.recommended(let p), .recommended(let x)): return p == x
        default:
            return false
        }
        
    }
}
