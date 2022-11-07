//
//  SpotID2TrkAPI.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 19/05/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

extension SpotifyTrackAPI {
    
    func getSpotifyTracksFromIdPack(ids: [String], authManager: AuthorisationManager, completion: @escaping (JSON?) -> ()) {
        guard let spotifyToken = authManager.spotifyToken else {
            completion(nil)
            return
        }
        
        let idsConcat = ids.joined(separator: ",")
        let url = "https://api.spotify.com/v1/tracks?ids=\(idsConcat)"
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(spotifyToken)")])
        
        AF.request(url, headers: headers).response { response in
            
            if response.response?.statusCode == 429 {
                SpotifyComponents().retry(response: response) {
                    self.getSpotifyTracksFromIdPack(ids: ids, authManager: authManager) { item in
                        completion(item)
                    }
                }
            } else {
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        completion(json)
                        return
                    }
                }
                completion(nil)
            }
            
        }
        
    }
    
}
