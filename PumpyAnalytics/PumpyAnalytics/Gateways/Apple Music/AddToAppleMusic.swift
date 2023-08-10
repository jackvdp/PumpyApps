//
//  AddToAppleMusic.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 10/08/2023.
//

import Foundation
import Alamofire

class AddToAppleMusicGateway {
    
    func add(playlistID: String,
             authManager: AuthorisationManager,
             completion: @escaping (Int?) -> ()) {
        
        guard let userToken = authManager.appleMusicToken else { completion(401); return }
        
        let url = "https://api.music.apple.com/v1/me/library?ids[playlists]=\(playlistID)"
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken),
            HTTPHeader(name: K.MusicStore.musicUserToken, value: userToken)
        ])
        
        AF.request(url,
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: headers).response { res in
            print("***", res.response?.statusCode)
            completion(res.response?.statusCode)
        }
        
    }
    
}
