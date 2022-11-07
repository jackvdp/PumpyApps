//
//  PlaybackModels.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/05/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation

public struct PlaybackItem: Codable {
    public init(itemID: String, trackName: String, trackArtistName: String, playlistName: String, playbackState: Int, versionNumber: String, queueIndex: Int) {
        self.itemID = itemID
        self.trackName = trackName
        self.trackArtistName = trackArtistName
        self.playlistName = playlistName
        self.playbackState = playbackState
        self.versionNumber = versionNumber
        self.queueIndex = queueIndex
    }
    
    var itemID: String
    var trackName: String
    var trackArtistName: String
    var playlistName: String
    var playbackState: Int
    var updateTime = Date()
    var versionNumber: String
    var queueIndex: Int
}

public struct TrackOnline: Hashable, Codable {
    public init(name: String, artist: String, id: String) {
        self.name = name
        self.artist = artist
        self.id = id
    }
    
    public var name: String
    public var artist: String
    public var id: String
}


public struct PlaylistOnline: Codable {
    public init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    var name: String
    var id: String
}
