//
//  SpotNextTracksAPI.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 08/05/2022.
//

import Foundation
import SwiftyJSON
import Alamofire

class SpotifyNextTrackAPI {
    
    func get(_ nextTracksURL: String,
             authManager: AuthorisationManager,
             completion: @escaping (JSON?, Error?) -> ()) {
        
        guard let spotToken = authManager.spotifyToken else {
            completion(nil, nil)
            return
        }
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: "Bearer \(spotToken)")
        ])
        
        AF.request(nextTracksURL, headers: headers).response { res in
            if let error = res.error {
                print(error)
                completion(nil, nil)
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
