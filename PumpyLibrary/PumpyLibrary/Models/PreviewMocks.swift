//
//  PreviewMocks.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import MusicKit

public struct MockData {
    public static let playlist = PreviewPlaylist(name: "Test", tracks: [], cloudGlobalID: "", representativeItem: nil)
    public static let tracks = Array(repeating: MockData.track, count: 20)
    public static let track = ConstructedTrack(title: "Test",
                                               artist: "Test",
                                               artworkURL: "https://is3-ssl.mzstatic.com/image/thumb/Music118/v4/37/0a/9e/370a9e4b-9f5e-5a22-21c9-205e8f07d271/00602547472533.rgb.jpg/200x200bb.jpg",
                                               playbackStoreID: "",
                                               isExplicitItem: true)
}

public struct PreviewPlaylist: Playlist {
    public var name: String?
    public var artwork: UIImage?
    public var tracks: [Track]
    public var cloudGlobalID: String?
    public var representativeItem: MPMediaItem?
    public var artworkURL: String?
}

public struct PreviewTrack: Track {
    public var title: String?
    public var artist: String?
    public var artwork: MPMediaItemArtwork?
    public var artworkURL: String?
    public var playbackStoreID: String
    public var isExplicitItem: Bool
    
    public func getBlockedTrack() -> BlockedTrack {
        return BlockedTrack(title: self.title,
                            artist: self.artist,
                            isExplicit: self.isExplicitItem,
                            playbackID: self.playbackStoreID)
    }
}
