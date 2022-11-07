//
//  GetSpotPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 07/05/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetSpotifyPlaylist {
    
    let authManager: AuthorisationManager
    let libraryPlaylist: PlaylistSnapshot
    
    init(libraryPlaylist: PlaylistSnapshot, authManager: AuthorisationManager) {
        self.authManager = authManager
        self.libraryPlaylist = libraryPlaylist
    }
    
    func execute(spotID: String, completion: @escaping (SpotifyPlaylist?, Error?) -> ()) {
        
        SpotifyPlaylistAPI().get(id: spotID, authManager: authManager) { jsonPlaylist, error in
            guard let jsonPlaylist = jsonPlaylist else {
                completion(nil, error)
                return
            }
            
            let playlistParseResult = SpotifyPlaylistParser().parse(jsonPlaylist, authManager: self.authManager)
            let spotPlaylist = playlistParseResult.0
            let nextTracksURL = playlistParseResult.1
            
            guard let spotPlaylist = spotPlaylist else {
                completion(nil, ErrorMessage("Error from Spotify", "Error retrieving playlist from Spotify server."))
                return
            }
            
            if let nextTracksURL = nextTracksURL {
                self.getMoreTracks(url: nextTracksURL, authManager: self.authManager) { tracks in
                    spotPlaylist.tracks.append(contentsOf: tracks)
                    completion(spotPlaylist, nil)
                }
            } else {
                completion(spotPlaylist, error)
            }
            
        }
        
    }
    
    private func getMoreTracks(url: String, authManager: AuthorisationManager, completion: @escaping ([Track]) -> ()) {
        SpotifyNextTrackAPI().get(url, authManager: self.authManager) { json, error in
            guard let json = json else {
                completion([])
                return
            }
            
            let tracksAndNext = SpotifyTracksParser().parseForTracksInPlaylist(json, authManager: authManager)
            var tracks = tracksAndNext.0
            
            if let nextURL = tracksAndNext.1 {
                self.getMoreTracks(url: nextURL, authManager: self.authManager) { newTracks in
                    tracks.append(contentsOf: newTracks)
                    completion(tracks)
                }
            } else {
                completion(tracks)
            }
        }
    }
    
}
