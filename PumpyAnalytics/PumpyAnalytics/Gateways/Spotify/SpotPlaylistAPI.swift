//
//  SpotifyPlaylistAPI.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 07/05/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpotifyPlaylistAPI {
    
    func get(id: String,
             authManager: AuthorisationManager,
             completion: @escaping (JSON?, Error?) -> ()) {
        
        guard let spotToken = authManager.spotifyToken else {
            let error = ErrorMessage("Invalid Token", "No Spotify token provided.")
            completion(nil, error)
            return
        }
        
        let url = "https://api.spotify.com/v1/playlists/\(id)"
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: "Bearer \(spotToken)")
        ])
        
        AF.request(url, headers: headers).response { res in
            if let error = res.error {
                print(error)
                completion(nil, error)
                return
            }
            
            guard let playlist = res.data else {
                completion(nil, nil)
                return
            }
            
            completion(JSON(playlist), nil)
        }
        
    }
    
}
