//
//  SpotifySearch.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 05/05/2022.
//

import Foundation
import SwiftyJSON

class SearchSpotify {
    
    private let gateway = SpotifySearchAPI()
    
    func run(_ term: String,
             authManager: AuthorisationManager,
             completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        
        gateway.run(term, authManager: authManager) { data, error in
            
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else {
                completion(nil, ErrorMessage("Error", "Error decoding playlists from Spotify server"))
                return
            }
            
            guard let jsonData = try? JSON(data: data) else {
                completion(nil, ErrorMessage("Error", "Error decoding playlists from Spotify server"))
                return
            }
            
            if let playlists = jsonData["playlists"]["items"].array {
                let libraryPlaylists = playlists.compactMap { playlist in
                    SpotifySearchParser().parseForPlaylist(playlist)
                }
                completion(libraryPlaylists, nil)
            } else {
                completion([], nil)
            }
            
        }
        
    }
    
}
