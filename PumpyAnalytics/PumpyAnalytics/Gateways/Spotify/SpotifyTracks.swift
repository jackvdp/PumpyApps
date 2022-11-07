//
//  SpotifyTracks.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 20/06/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpotifyTracksGateway {
    
    func run(trackIDs: [String], authManager: AuthorisationManager, completion: @escaping ([Track], ErrorMessage?) -> ()) {
        
        guard let spotifyToken = authManager.spotifyToken else {
            completion([], ErrorMessage("Error conducting Spotify search", "No authorisation token found."))
            return
        }
        
        let query = trackIDs.joined(separator: ",")
        
        let url = "https://api.spotify.com/v1/tracks?ids=\(query)"
        
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
                completion([], em)
                return
            }
            
            guard let data = res.data else {
                let em = ErrorMessage("Error conducting Spotify search", "Error loading data.")
                completion([], em)
                return
            }
            
            if res.response?.statusCode != 200 {
                let em = ErrorMessage("Error conducting Spotify search", "Invalid request.")
                completion([], em)
                return
            }
            
            let jsonData = JSON(data)
            let tracks = SpotifyTracksParser().parseForTracks(tracks: jsonData,
                                                              authManager: authManager)
            
            completion(tracks, nil)
            
        }
        
    }
}
