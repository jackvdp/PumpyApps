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

extension MPMediaItem: Track {
    
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
}

extension MPMediaPlaylist: Playlist, ScheduledPlaylist {
    public var tracks: [Track] {
        return items
    }
}

