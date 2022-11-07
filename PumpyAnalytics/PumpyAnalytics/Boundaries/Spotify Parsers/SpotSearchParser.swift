//
//  SpotifySearchParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 05/05/2022.
//

import Foundation
import SwiftyJSON

class SpotifySearchParser {
    
    func parseForPlaylist(_ json: JSON) -> PlaylistSnapshot? {
        
        if let id = json["id"].string {
            
            let name = json["name"].string
            var artworkURL: String? = nil
            if let artworkURLs = json["images"].array {
                if let artworkJSON = artworkURLs.first {
                    artworkURL = artworkJSON["url"].string
                }
            }
            let description = json["description"].string
            
            return PlaylistSnapshot(
                name: name,
                artworkURL: artworkURL,
                shortDescription: description,
                sourceID: id,
                type: .spotify(id: id)
            )
        }
        
        return nil
    }
    
}
