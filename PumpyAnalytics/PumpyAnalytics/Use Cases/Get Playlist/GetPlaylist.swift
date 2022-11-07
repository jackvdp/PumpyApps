//
//  GetPlaylist.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 26/05/2022.
//

import Foundation

class GetPlaylist {
    
    func execute(snapshot: PlaylistSnapshot,
                 authManager: AuthorisationManager,
                 completion: @escaping (Playlist?, ErrorMessage?) -> ()) {
        switch snapshot.type {
        case .syb(let id):
            GetSYBPlaylist(libraryPlaylist: snapshot,
                           authManager: authManager).execute(sybID: id) { playlist, error in
                
                completion(playlist, error)
            }
        case .custom(let logic):
            GetCustomPlaylist(libraryPlaylist: snapshot,
                              authManager: authManager).execute(logic: logic) { playlist, error in
                
                completion(playlist, error)
            }
        case.am(let id):
            GetAMPlaylist(libraryPlaylist: snapshot,
                          authManager: authManager).execute(amID: id) { playlist, error in
                
                var em: ErrorMessage?
                if let e = error {
                    em = ErrorMessage("Error getting Apple Music Playlist", e.localizedDescription)
                }
                
                completion(playlist, em)
            }
        case .spotify(let id):
            GetSpotifyPlaylist(libraryPlaylist: snapshot,
                               authManager: authManager).execute(spotID: id) { spotPlaylist, error in
                
                var em: ErrorMessage?
                if let e = error {
                    em = ErrorMessage("Error getting Spotify Playlist", e.localizedDescription)
                }
                
                completion(spotPlaylist, em)
            }
        case .recommended(let tracks):
            GetRecommendedPlaylist().execute(snapshot: snapshot,
                                             trackIDs: tracks,
                                             authManager: authManager,
                                             completion: completion)
        case .text:
            print("Not implemented")
        }
    }
    
}
