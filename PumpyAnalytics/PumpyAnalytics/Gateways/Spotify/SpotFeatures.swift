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
    
    func getManyAudioFeaturesFromSpotifyID(ids: [String], authManager: AuthorisationManager) async -> [AudioFeatures] {
        guard let token = authManager.spotifyToken else { return [] }
        
        let url = "https://api.spotify.com/v1/audio-features/?ids=\(ids.joined(separator: ","))"
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(token)")])
        
        let response = await AF.request(url, headers: headers).serializingData().response
        
        guard response.response?.statusCode != 429 else {
            await spotifyComponents.retryAsync(response: response)
            return await getManyAudioFeaturesFromSpotifyID(ids: ids, authManager: authManager)
        }
        
        guard let data = response.data else { return [] }
        let features = self.spotifyParser.parseForManyTrackFeatures(data: data)
        print("\(features.count) features || for \(ids.count) ids")
        return features
    }
    
}
