//
//  SpotifyAPI.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/03/2022.
//

import Foundation
import SwiftyJSON
import Alamofire

class SpotifyFeaturesAPI {
    
    let authManager: AuthorisationManager
    let spotifyParser = SpotifyFeaturesParser()
    
    init(_ authManager: AuthorisationManager) {
        self.authManager = authManager
    }
    
    func getAudioFeaturesFromSpotifyID(id: String, completion: @escaping (AudioFeatures?) -> ()) {
        guard let token = authManager.spotifyToken else {
            completion(nil)
            return
        }
        
        if let musicURL = URL(string: "https://api.spotify.com/v1/audio-features/\(id)") {
            let musicRequest = SpotifyComponents().request(musicURL, token: token)
            URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                guard error == nil else {
                    completion(nil)
                    return
                }
                if let d = data {
                    if let features = self.spotifyParser.parseForTrackFeatures(data: d) {
                        completion(features)
                        return
                    }
                }
                completion(nil)
            }.resume()
        }
    }
    
    func getManyAudioFeaturesFromSpotifyID(ids: [String], completion: @escaping ([AudioFeatures]) -> ()) {
        guard let token = authManager.spotifyToken else {
            completion([])
            return
        }
        
        let url = "https://api.spotify.com/v1/audio-features/?ids=\(ids.joined(separator: ","))"
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(token)")])
        
        AF.request(url, headers: headers).response { response in
            if response.response?.statusCode == 429 {
                SpotifyComponents().retry(response: response) {
                    self.getManyAudioFeaturesFromSpotifyID(ids: ids) { features in
                        completion(features)
                    }
                }
            } else {
                if let d = response.data {
                    let features = self.spotifyParser.parseForManyTrackFeatures(data: d)
                    print("\(features.count) features || for \(ids.count) ids")
                    completion(features)
                    return
                }
                completion([])
            }
        }
            
    }
    
}
