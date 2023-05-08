//
//  Remote Models.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 24/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation

public struct RemoteInfo: Codable {
    public init(command: RemoteEnum) {
        remoteCommand = command
    }
    
    public init() {}
    
    public var remoteCommand: RemoteEnum?
    public var updateTime = Date()
}

public enum RemoteEnum {
    case playPause
    case skipTrack
    case previousTrack
    case playPlaylistNow(playlist: String)
    case playPlaylistNext(playlist: String)
    case playCatalogPlaylistNow(id: String)
    case playCatalogPlaylistNext(id: String)
    case getLibraryPlaylists
    case removeTrackFromQueue(id: String)
    case addToQueue(queueIDs: [String])
    case activeInfo
    case increaseEnergy
    case decreaseEnergy
}

extension RemoteEnum: Codable {
    
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        switch self {
        case .playPause:
            try container.encode("playPause", forKey: .rawValue)
            
        case .skipTrack:
            try container.encode("skipTrack", forKey: .rawValue)
            
        case .previousTrack:
            try container.encode("previousTrack", forKey: .rawValue)
            
        case .playPlaylistNow(let playlist):
            try container.encode("playPlaylistNow", forKey: .rawValue)
            try container.encode(playlist, forKey: .associatedValue)
            
        case .playPlaylistNext(let playlist):
            try container.encode("playPlaylistNext", forKey: .rawValue)
            try container.encode(playlist, forKey: .associatedValue)
            
        case .getLibraryPlaylists:
            try container.encode("getLibraryPlaylists", forKey: .rawValue)
 
        case .removeTrackFromQueue(let id):
            try container.encode("removeTrackFromQueue", forKey: .rawValue)
            try container.encode(id, forKey: .associatedValue)
            
        case .addToQueue(let queue):
            try container.encode("addToQueue", forKey: .rawValue)
            try container.encode(queue, forKey: .associatedValue)
            
        case .activeInfo:
            try container.encode("activeInfo", forKey: .rawValue)
            
        case .increaseEnergy:
            try container.encode("increaseEnergy", forKey: .rawValue)
            
        case .decreaseEnergy:
            try container.encode("decreaseEnergy", forKey: .rawValue)
            
        case .playCatalogPlaylistNow(id: let id):
            try container.encode("playCatalogPlaylistNow", forKey: .rawValue)
            try container.encode(id, forKey: .associatedValue)
            
        case .playCatalogPlaylistNext(id: let id):
            try container.encode("playCatalogPlaylistNext", forKey: .rawValue)
            try container.encode(id, forKey: .associatedValue)
        }
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        
        switch rawValue {
        case "playPause":
            self = .playPause
        case "skipTrack":
            self = .skipTrack
        case "previousTrack":
            self = .previousTrack
        case "playPlaylistNow":
            let playlist = try container.decode(String.self, forKey: .associatedValue)
            self = .playPlaylistNow(playlist: playlist)
        case "playPlaylistNext":
            let playlist = try container.decode(String.self, forKey: .associatedValue)
            self = .playPlaylistNext(playlist: playlist)
        case "getLibraryPlaylists":
            self = .getLibraryPlaylists
        case "removeTrackFromQueue":
            let id = try container.decode(String.self, forKey: .associatedValue)
            self = .removeTrackFromQueue(id: id)
        case "addToQueue":
            let tracks = try container.decode([String].self, forKey: .associatedValue)
            self = .addToQueue(queueIDs: tracks)
        case "activeInfo":
            self = .activeInfo
        case "increaseEnergy":
            self = .increaseEnergy
        case "decreaseEnergy":
            self = .decreaseEnergy
        default:
            throw CodingError.unknownValue
        }
    }
    
}
