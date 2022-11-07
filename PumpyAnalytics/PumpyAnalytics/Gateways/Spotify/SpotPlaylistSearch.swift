//
//  SpotifySearch.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 05/05/2022.
//

import Foundation
import Alamofire

class SpotifySearchAPI {
    
    func run(_ term: String, authManager: AuthorisationManager, completion: @escaping (Data?, ErrorMessage?) -> ()) {
        
        guard let spotifyToken = authManager.spotifyToken else {
            completion(nil, ErrorMessage("Error conducting Spotify search", "No authorisation token found."))
            return
        }
        
        guard let query = makeURLSafe(queryName: "q", value: term) else {
            completion(nil, ErrorMessage("Error conducting Spotfy search", "Invalid search term."))
            return
        }
        
        let url = "https://api.spotify.com/v1/search?\(query)&type=playlist&limit=50"
        
        let headers = HTTPHeaders(
            [
                HTTPHeader(name: "Authorization",
                           value: "Bearer \(spotifyToken)")
            ]
        )
        
        AF.request(url, headers: headers).response { res in
            
            if let error = res.error {
                print(error)
                let em = ErrorMessage("Error conducting Spotify search", "Error loading data \(error.localizedDescription).")
                completion(nil, em)
                return
            }
            
            completion(res.data, nil)
            
        }
        
    }
    
}
