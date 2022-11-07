//
//  RecommendationsAPI.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 02/09/2022.
//

import Foundation
import Alamofire

class SuggestionsGateway {
    
    private let url = "https://api.music.apple.com/v1/me/recommendations/"
    
    func get(authManager: AuthorisationManager, completion: @escaping (Suggestions?, Int)->()) {
        guard let musicUserToken = authManager.appleMusicToken else { completion(nil, 400); return }

        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.musicUserToken, value: musicUserToken),
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken)
        ])
        
        AF.request(url, headers: headers).responseDecodable(of: Suggestions.self) { response in
            completion(response.value, response.response?.statusCode ?? 400)
        }
        
    }
    
}
