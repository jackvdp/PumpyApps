//
//  SearchTracksAPI.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 15/09/2022.
//

import Foundation
import Alamofire

class SearchTracksGateway: SearchTracksGatewayProtocol {
    
    func run(_ term: String, limit: Int, authManager: AuthorisationManager, completion: @escaping (SongSearchResults?, Int) -> ()) {
        let url = "https://api.music.apple.com/v1/catalog/\(authManager.storefront ?? "gb")/search?limit=\(limit)&types=songs&term=\(term.makeURLSafe())"
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken)
        ])
        
        AF.request(url, headers: headers).responseDecodable(of: SongSearchResults.self) { res in
                        
            guard let results = res.value else {
                print(res.error?.localizedDescription ?? "Error conducting search")
                completion(nil, (res.response?.statusCode ?? 400) + 10)
                return
            }
            
            completion(results, res.response?.statusCode ?? 200)
        }
        
    }
    
}

protocol SearchTracksGatewayProtocol {
    func run(_ term: String, limit: Int, authManager: AuthorisationManager, completion: @escaping (SongSearchResults?, Int) -> ())
}
