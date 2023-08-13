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
    
    private let spotifyHelpers = SpotifyComponents()
    
    func getSpotifyTrackFromISRC(isrc: String, authManager: AuthorisationManager) async -> SpotifyItem? {
        let url = "https://api.spotify.com/v1/search?type=track&q=isrc:\(isrc)"
        guard let spotifyToken = authManager.spotifyToken else { return nil }
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(spotifyToken)")])
        
        let response = await AF.request(url, headers: headers).serializingData().response
        
        guard response.response?.statusCode != 429 else {
            await spotifyHelpers.retryAsync(response: response)
            return await self.getSpotifyTrackFromISRC(isrc: isrc, authManager: authManager)
        }
        
        do {
            if let data = response.data, let json = try? JSON(data: data) {
                return SpotifyItemParser().parseForSpotifyItemInSearch(json)
            }
            return nil
        }
        
    }
    
}
