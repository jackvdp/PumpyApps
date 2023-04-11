//
//  SpotGenres.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 11/04/2023.
//

import Foundation
import Alamofire

class SpotifyGenresGateway {
    
    func run(authManager: AuthorisationManager, completion: @escaping ([String], ErrorMessage?) -> ()) {

        guard let spotifyToken = authManager.spotifyToken else {
            completion([], ErrorMessage("Error conducting Spotify search", "No authorisation token found."))
            return
        }
        
        let headers = HTTPHeaders(
            [
                HTTPHeader(name: "Authorization",
                           value: "Bearer \(spotifyToken)")
            ]
        )
        
        let url = "https://api.spotify.com/v1/recommendations/available-genre-seeds"
        
        AF.request(url, headers: headers).responseDecodable(of: GenreModel.self) { res in
            
            if let error = res.error {
                print(error)
                let em = ErrorMessage("Error conducting Spotify search", "Error loading data \(error.localizedDescription).")
                completion([], em)
                return
            }

            if res.response?.statusCode != 200 {
                let em = ErrorMessage("Error conducting Spotify search", "Invalid request.")
                completion([], em)
                return
            }

            
            completion(res.value?.genres ?? [], nil)
            
        }
        
    }
}

struct GenreModel: Codable {
    var genres: [String]
}
