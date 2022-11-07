//
//  SearchAPI.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/04/2022.
//

import Foundation
import Alamofire

class AMSearchAPI {
    
    func run(_ term: String, next: String? = nil, authManager: AuthorisationManager, completion: @escaping (Data?, ErrorMessage?) -> ()) {
        guard let userToken = authManager.appleMusicToken else {
            completion(nil, ErrorMessage("Error conducting Apple Music search", "No authorisation token found."))
            return
        }
        
        guard let query = makeURLSafe(queryName: "term", value: term) else {
            completion(nil, ErrorMessage("Error conducting Apple Music search", "Invalid search term."))
            return
        }
        
        let url = "https://api.music.apple.com" + (next ?? "/v1/catalog/\(authManager.storefront ?? "gb")/search?limit=25&types=playlists&\(query)")
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken),
            HTTPHeader(name: K.MusicStore.musicUserToken, value: userToken)
        ])
        
        AF.request(url, headers: headers).response { res in
            if let error = res.error {
                print(error)
                let em = ErrorMessage("Error conducting Apple Music search", "Error loading data \(error.localizedDescription).")
                completion(nil, em)
                return
            }
            
            completion(res.data, nil)
        }
        
    }
    
}
