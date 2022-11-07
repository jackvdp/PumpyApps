//
//  PlaylistAPI.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/04/2022.
//

import Foundation
import MusicKit
import Alamofire
import SwiftyJSON

class AMPlaylistAPI {
    
    func get(id: String,
             authManager: AuthorisationManager,
             next: String? = nil,
             completion: @escaping (MusicKit.Playlist?, [MusicKit.Track], Error?) -> ()) {
        
        guard let userToken = authManager.appleMusicToken else { return }
        let url = "https://api.music.apple.com/v1/catalog/gb/playlists/\(id)?include=tracks"
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken),
            HTTPHeader(name: K.MusicStore.musicUserToken, value: userToken)
        ])
        
        AF.request(url, headers: headers).responseDecodable(of: PlaylistResponse.self) { res in
            
            if let error = res.error {
                print(error)
                completion(nil, [], error)
                return
            }
            
            guard let playlists = res.value?.data else { completion(nil, [], nil); return }
            
            if let playlist = playlists.first {
                var tracks = [MusicKit.Track]()
                 
                tracks.append(contentsOf: playlist.tracks ?? [])

                self.getNextPageOfTracks(tracks: playlist.tracks) { newTracks in
                    tracks.append(contentsOf: newTracks ?? [])

                    if !(newTracks?.hasNextBatch ?? false) {
                        completion(playlist, tracks, nil)
                    }
                }
            }
            
        }
    }
    
    private func getNextPageOfTracks(tracks: MusicItemCollection<MusicKit.Track>?,
                                     completion: @escaping (MusicItemCollection<MusicKit.Track>?) -> ()) {
        Task {
            let newTracks = await self.doAsyncWork(tracks: tracks)
            completion(newTracks)
            if newTracks?.hasNextBatch ?? false {
                getNextPageOfTracks(tracks: newTracks) { nextTracks in
                    completion(nextTracks)
                }
            }
        }
    }
    
    private func doAsyncWork(tracks: MusicItemCollection<MusicKit.Track>?) async -> MusicItemCollection<MusicKit.Track>? {
        return try? await tracks?.nextBatch(limit: nil)
    }

}

struct PlaylistResponse: Decodable {
    let data: [MusicKit.Playlist]
    let next: String?
}
