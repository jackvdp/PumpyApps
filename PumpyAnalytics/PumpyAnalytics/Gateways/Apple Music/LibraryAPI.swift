//
//  LibraryAPI.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/03/2022.
//

import Foundation
import Alamofire
import MusicKit
import SwiftyJSON

class AMLibraryAPI {
    
    func getPlaylists(authManager: AuthorisationManager, next: String? = nil, completion: @escaping ([PlaylistSnapshot], AFError?) -> ()) {
        guard let userToken = authManager.appleMusicToken else { return }
        
        let url = "https://api.music.apple.com" + (next ?? "/v1/me/library/playlists")
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken),
            HTTPHeader(name: K.MusicStore.musicUserToken, value: userToken)
        ])
        
        AF.request(url, headers: headers).responseDecodable(of: LibraryResponse.self) { res in
            
            if let error = res.error {
                print(error)
                completion([], error)
                return
            }

            if let next = res.value?.next {
                self.getPlaylists(authManager: authManager, next: next) { playlists, error in
                    completion(playlists, error)
                }
            }
            
            guard let libraryData = res.data else {completion([], nil); return}
            
            let playlists = LibraryParser().parseForPlaylists(data: libraryData, fromCatalog: false)
            
            completion(playlists, nil)
        }
    }
    
}

struct LibraryResponse: Decodable {
    let next: String?
}
