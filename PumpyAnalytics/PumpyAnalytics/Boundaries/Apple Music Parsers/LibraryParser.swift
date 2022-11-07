//
//  LibraryParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 20/04/2022.
//

import Foundation
import SwiftyJSON

class LibraryParser {
    
    func parseForPlaylists(data: Data, fromCatalog: Bool) -> [PlaylistSnapshot] {
        
        guard let json = JSON(data)["data"].array else { return [] }
        
        let playlists: [PlaylistSnapshot] = json.compactMap { playlistJSON in

            if fromCatalog {
                return parseForPlaylistFromCatalog(playlistJSON)
            } else {
                return parseForPlaylistFromMe(playlistJSON)
            }
            
        }
        
        return playlists
    }
    
    func parseForPlaylistFromCatalog(_ json: JSON) -> PlaylistSnapshot? {
        if let globalID = json["attributes"]["playParams"]["id"].string {
            
            let name = json["attributes"]["name"].string
            let artworkURL = json["attributes"]["artwork"]["url"].string
            let description = json["attributes"]["description"]["standard"].string

            return PlaylistSnapshot(
                name: name,
                artworkURL: artworkURL,
                shortDescription: description,
                sourceID: globalID,
                type: .am(id: globalID)
            )
            
        }
        return nil
    }
    
    func parseForPlaylistFromMe(_ json: JSON) -> PlaylistSnapshot? {

        if let globalID = json["attributes"]["playParams"]["globalId"].string {
            
            let name = json["attributes"]["name"].string
            let artworkURL = json["attributes"]["artwork"]["url"].string
            let description = json["attributes"]["description"]["standard"].string

            return PlaylistSnapshot(
                name: name,
                artworkURL: artworkURL,
                shortDescription: description,
                sourceID: globalID,
                type: .am(id: globalID)
            )
            
        }
        return nil
    }
    
}
