//
//  CreatePlaylisty.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/03/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class AMCreatePlaylistAPI {
    
    func createPlaylist(name: String, tracks: [Track], authManager: AuthorisationManager, completion: @escaping (Int?) -> ()) {
        guard let userToken = authManager.appleMusicToken else { return }
        
        let url = "https://api.music.apple.com/v1/me/library/playlists"
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken),
            HTTPHeader(name: K.MusicStore.musicUserToken, value: userToken)
        ])
        let trackIDs = tracks.compactMap { $0.appleMusicItem?.id }
        let playlistRequest = PlaylistRequest(name: name, trackIDs: trackIDs)
        
        AF.request(url,
                   method: .post,
                   parameters: playlistRequest.dictionary,
                   encoding: JSONEncoding.default,
                   headers: headers).response { res in

            completion(res.response?.statusCode)
        }

    }
    
    
}
