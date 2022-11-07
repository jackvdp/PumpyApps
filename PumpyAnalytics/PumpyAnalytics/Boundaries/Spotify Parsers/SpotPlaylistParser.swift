//
//  SpotPlaylistParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 07/05/2022.
//

import Foundation
import SwiftyJSON

class SpotifyPlaylistParser {
    
    func parse(_ json: JSON, authManager: AuthorisationManager) -> (SpotifyPlaylist?, String?) {
        
        if let id = json["id"].string {
            
            var artworkURL: String?
            if let artworks = json["images"].array {
                if let lastArtwork = artworks.first {
                    artworkURL = lastArtwork["url"].string
                }
            }
            
            let tracksParse = SpotifyTracksParser().parseForTracksInPlaylist(json["tracks"], authManager: authManager)
            
            let playlist = SpotifyPlaylist(
                name: json["name"].string,
                curator: json["owner"]["display_name"].string ?? "Spotify",
                tracks: tracksParse.0,
                artworkURL: artworkURL,
                description: json["description"].string,
                shortDescription: json["description"].string,
                sourceID: id,
                authManager: authManager)
            
            return (playlist, tracksParse.1)
            
        } else {
            return (nil, nil)
        }
    }
    
}
