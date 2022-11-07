//
//  SpotItemParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 08/05/2022.
//

import Foundation
import SwiftyJSON

class SpotifyItemParser {
    
    func parseForSpotifyItem(_ jsonTrack: JSON) -> SpotifyItem? {
        
        if let id = jsonTrack["id"].string,
           let isrc = jsonTrack["external_ids"]["isrc"].string {
            
            var year: Int? {
                if let year = jsonTrack["album"]["release_date"].string {
                    if let stringYear = year.split(whereSeparator: { $0 == "-" }).first {
                        return Int(stringYear)
                    }
                }
                return nil
            }
            
            return SpotifyItem(
                isrc: isrc,
                id: id,
                year: year,
                popularity: jsonTrack["popularity"].int
            )
            
        }
        
        return nil
    }
    
    func parseForSpotifyItemInSearch(_ jsonData: JSON) -> SpotifyItem? {

        if let items = jsonData["tracks"]["items"].array {
            for track in items {
                if let item = parseForSpotifyItem(track) {
                    return item
                }
            }
        }
        return nil
    }
    
    func parseForSpotifyItemsFromTracksAPI(_ jsonData: JSON) -> [SpotifyItem] {
        
        var items = [SpotifyItem]()
        
        if let tracks = jsonData["tracks"].array {
            for track in tracks {
                if let item = parseForSpotifyItem(track) {
                    items.append(item)
                }
            }
        }
        return items
    }
    
}
