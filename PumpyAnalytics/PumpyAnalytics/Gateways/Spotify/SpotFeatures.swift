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
    
    let spotifyParser = SpotifyFeaturesParser()
    let spotifyComponents = SpotifyComponents()
    
    func getAudioFeaturesFromSpotifyID(id: String, authManager: AuthorisationManager, completion: @escaping (AudioFeatures?) -> ()) {
        guard let token = authManager.spotifyToken else {
            completion(nil)
            return
        }
        
        if let musicURL = URL(string: "https://api.spotify.com/v1/audio-features/\(id)") {
            let musicRequest = SpotifyComponents().request(musicURL, token: token)
            URLSession.shared.dataTask(with: musicRequest) { [weak self] (data, response, error) in
                guard let self else { return }
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
    
    func getManyAudioFeaturesFromSpotifyID(ids: [String], authManager: AuthorisationManager, completion: @escaping ([AudioFeatures]) -> ()) {
        guard let token = authManager.spotifyToken else {
            completion([])
            return
        }
        
        let url = "https://api.spotify.com/v1/audio-features/?ids=\(ids.joined(separator: ","))"
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(token)")])
        
        AF.request(url, headers: headers).response { [weak self] response in
            guard let self else { return }
            
            if response.response?.statusCode == 429 {
                self.spotifyComponents.retry(response: response) { [weak self] in
                    guard let self else { return }
                    self.getManyAudioFeaturesFromSpotifyID(ids: ids, authManager: authManager, completion: completion)
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
