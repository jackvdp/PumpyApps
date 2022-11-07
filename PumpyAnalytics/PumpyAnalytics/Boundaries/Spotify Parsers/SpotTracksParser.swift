//
//  SpotTracksParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 08/05/2022.
//

import Foundation
import SwiftyJSON
import Alamofire

class SpotifyTracksParser {
    
    func parseForTracksInPlaylist(_ json: JSON, authManager: AuthorisationManager) -> ([Track], String?) {
        if let jsonItems = json["items"].array {
            let nextTracksURL = json["next"].string
            let items = parseForTracksInItems(jsonItems, authManager: authManager)
            return (items, nextTracksURL)
        } else {
            return ([], nil)
        }
    }
    
    func parseForTracksInItems(_ jsonItems: [JSON], authManager: AuthorisationManager) -> [Track] {
        var tracks = [Track]()
        
        for jsonTrack in jsonItems {
            if let track = parseForTrack(jsonTrack["track"], authManager: authManager) {
                tracks.append(track)
            }
        }
        
        return tracks
        
    }
    
    func parseForTrack(_ jsonTrack: JSON, authManager: AuthorisationManager) -> Track? {
        if let id = jsonTrack["id"].string,
           let isrc = jsonTrack["external_ids"]["isrc"].string {
            
            var artistsString: String? {
                if let artists = jsonTrack["artists"].array {
                    var artistsArray = [String]()
                    for artist in artists {
                        if let artistString = artist["name"].string {
                            artistsArray.append(artistString)
                        }
                    }
                    return artistsArray.joined(separator: ", ")
                }
                return nil
            }
            
            var artworkURL: String? {
                if let artworks = jsonTrack["album"]["images"].array {
                    if let artwork = artworks.last {
                        return artwork["url"].string
                    }
                }
                return nil
            }
            
            let item = SpotifyItemParser().parseForSpotifyItem(jsonTrack)
            
            let track = Track(
                title: jsonTrack["name"].string ?? "N/A",
                artist: artistsString ?? "N/A",
                album: jsonTrack["album"]["name"].string ?? "N/A",
                isrc: isrc,
                artworkURL: artworkURL,
                previewUrl: jsonTrack["preview_url"].string,
                isExplicit: jsonTrack["explicit"].bool ?? false,
                sourceID: id,
                authManager: authManager,
                appleMusicItem: nil,
                spotifyItem: item
            )
            
            return track
        }
        return nil
    }
    
    func parseForTracks(tracks: JSON,
                                 authManager: AuthorisationManager) -> [Track] {
        
        var tracksStruct = [Track]()
        
        if let array = tracks["tracks"].array {
            for item in array {
                if let parsed = parseForTrack(item, authManager: authManager) {
                    tracksStruct.append(parsed)
                }
            }
        }
        
        return tracksStruct
    }
    
}
