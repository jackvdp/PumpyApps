//
//  Model.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 22/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import PumpyLibrary
import MusicKit
import PumpyAnalytics

extension MusicKit.Playlist: PumpyLibrary.Playlist {
    
    public var title: String? {
        return name
    }
    
    public var artworkURL: String? {
        let key = PumpyAnalytics.K.MusicStore.artworkKey
        return self.artwork?.url(width: key, height: key)?.absoluteString
    }
    
    public var songs: [PumpyLibrary.Track] {
        let tracks: [MusicKit.Track] = tracks!.map { $0 }
        return tracks
    }
    
    public var cloudGlobalID: String? {
        return id.rawValue
    }
    
    public var longDescription: String? {
        return self.standardDescription
    }
    
}

extension MusicKit.Track: PumpyLibrary.Track {
    public var name: String {
        self.title
    }
    
    public var artworkURL: String? {
        self.artwork?.url(width: K.MusicStore.artworkKey, height: K.MusicStore.artworkKey)?.absoluteString
    }
    
    public var amStoreID: String? {
        self.id.rawValue
    }
    
    public var isExplicitItem: Bool {
        self.contentRating == .explicit
    }
    
}
