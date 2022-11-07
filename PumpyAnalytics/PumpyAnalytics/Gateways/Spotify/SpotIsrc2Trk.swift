//
//  SpotifyISRC.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/03/2022.
//

import Foundation
import SwiftyJSON
import Alamofire

class SpotifyTrackAPI {
    
    func getSpotifyTrackFromISRC(isrc: String, authManager: AuthorisationManager, completion: @escaping (SpotifyItem?) -> ()) {
        let url = "https://api.spotify.com/v1/search?type=track&q=isrc:\(isrc)"
        guard let spotifyToken = authManager.spotifyToken else {
            completion(nil)
            return
        }
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(spotifyToken)")])
        
        AF.request(url, headers: headers).response { response in
            
            if response.response?.statusCode == 429 {
                SpotifyComponents().retry(response: response) {
                    self.getSpotifyTrackFromISRC(isrc: isrc, authManager: authManager) { item in
                        completion(item)
                    }
                }
            } else {
                do {
                    if let data = response.data {
                        if let json: JSON = try? JSON(data: data) {
                            let item = SpotifyItemParser().parseForSpotifyItemInSearch(json)
                            completion(item)
                            return
                        }
                    }
                    completion(nil)
                }
            }
        }
        
    }
    
}
