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
    
    func getSpotifyTracksFromIdPack(ids: [String], authManager: AuthorisationManager) async -> JSON? {
        guard let spotifyToken = authManager.spotifyToken else { return nil }
        
        let idsConcat = ids.joined(separator: ",")
        let url = "https://api.spotify.com/v1/tracks?ids=\(idsConcat)"
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(spotifyToken)")])
        
        let response = await AF.request(url, headers: headers).serializingData().response
        
        guard response.response?.statusCode != 429 else {
            await SpotifyComponents().retryAsync(response: response)
            return await getSpotifyTracksFromIdPack(ids: ids, authManager: authManager)
        }
        
        if let data = response.data, let json = try? JSON(data: data) {
            return json
        }
        return nil
    }
    
}
