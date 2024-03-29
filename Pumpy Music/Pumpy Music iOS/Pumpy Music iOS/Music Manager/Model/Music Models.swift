//
//  Model.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 22/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import SwiftUI
import PumpyLibrary
import PumpyAnalytics

extension MPMediaItem: PumpyLibrary.Track {
    
    public var name: String {
        self.title ?? ""
    }
    
    public var artistName: String {
        self.artist ?? ""
    }
    
    public var amStoreID: String? {
        self.playbackStoreID
    }
    
    public var artworkURL: String? {
        if let catalog = value(forKey: "artworkCatalog") as? NSObject,
           let token = catalog.value(forKey: "token") as? NSObject,
           let url = token.value(forKey: "availableArtworkToken") as? String ??
                     token.value(forKey: "fetchableArtworkToken") as? String {
            if url.contains("https:") {
                return url.replacingOccurrences(of: "600x600", with: "{w}x{w}")
            } else {
                return "https://is3-ssl.mzstatic.com/image/thumb/\(url)/{w}x{w}.jpg"
            }
        }
        return nil
    }
    
    public func analyticsTrack(authManager: PumpyAnalytics.AuthorisationManager) -> PumpyAnalytics.Track {
        PumpyAnalytics.Track(title: title ?? "", artist: artistName, album: albumTitle ?? "", isrc: nil, artworkURL: artworkURL, previewUrl: nil, isExplicit: isExplicitItem, sourceID: playbackStoreID, authManager: authManager)
    }

}

extension MPMediaPlaylist: PumpyLibrary.Playlist, ScheduledPlaylist {
    
    public var shortDescription: String? {
        descriptionText
    }
    
    public var longDescription: String? {
        descriptionText
    }
    
    public var title: String? {
        name
    }
    
    public var songs: [PumpyLibrary.Track] {
        items
    }
    
    public var curator: String {
        authorDisplayName ?? ""
    }
    
    public var type: PumpyAnalytics.PlaylistType {
        .am(id: cloudGlobalID ?? "")
    }
    
    public var sourceID: String {
        cloudGlobalID ?? ""
    }
    
}

