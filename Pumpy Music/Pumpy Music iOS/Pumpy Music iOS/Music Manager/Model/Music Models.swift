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
        let key = ArtworkHandler.key
        return self.artwork?.url(width: key, height: key)?
            .absoluteString
            .pullOutArtworkURL()
    }
    
    public var songs: [PumpyLibrary.Track] {
        guard let tracks else { return [] }
        let t: [MusicKit.Track] = tracks.map { $0 }
        return t
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
        self.artwork?
            .url(width: ArtworkHandler.key, height: ArtworkHandler.key)?
            .absoluteString
            .pullOutArtworkURL()
    }
    
    public var amStoreID: String? {
        self.id.rawValue
    }
    
    public var isExplicitItem: Bool {
        self.contentRating == .explicit
    }
    
}

extension ApplicationMusicPlayer.Queue: NowPlayingProtocol {
    public var currentTrack: PumpyLibrary.Track? {
        self.currentEntry
    }
}

extension MusicPlayer.Queue.Entry: PumpyLibrary.Track {
    public var name: String {
        self.title
    }
    
    public var artistName: String {
        switch item {
        case .song(let song):
            return song.artistName
        case .musicVideo(let song):
            return song.artistName
        default:
            return ""
        }
    }
    
    public var artworkURL: String? {
        let key = ArtworkHandler.key
        return self.artwork?.url(
            width: key,
            height: key)?
            .absoluteString
            .pullOutArtworkURL()
    }
    
    public var amStoreID: String? {
        self.id
    }
    
    public var isExplicitItem: Bool {
        switch item {
        case .song(let song):
            return song.contentRating == .explicit
        case .musicVideo(let song):
            return song.contentRating == .explicit
        default:
            return false
        }
    }
    
}

extension String {
    fileprivate func pullOutArtworkURL() -> String {
        let (fat, aat) = extractParams(from: self)
        guard let url = fat ?? aat else { return self }
        
        if let range = url.range(of: "https://") {
            let suffix = url.suffix(from: range.lowerBound)
            return String(suffix)
        } else {
            let baseURL = "https://is2-ssl.mzstatic.com/image/thumb/"
            let sizeSuffix = "/{w}x{w}bb.jpg"
            return baseURL + url + sizeSuffix
        }
    }
    
    func extractParams(from input: String) -> (fat: String?, aat: String?) {
        var fat: String? = nil
        var aat: String? = nil
        let components = input.split(separator: "&")
        for component in components {
            let keyValue = component.split(separator: "=")
            if keyValue.count == 2 {
                let key = keyValue[0]
                let value = keyValue[1]
                if key == "fat" {
                    fat = String(value)
                } else if key == "aat" {
                    aat = String(value)
                }
            }
        }
        return (fat: fat, aat: aat)
    }
    
}
