//
//  GetTracksFromManyPlaylists.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/03/2022.
//

import Foundation

class GetTracksFromManyPlaylists {

    func execute(libraryPlaylists: [PlaylistSnapshot],
                 authManager: AuthorisationManager,
                 completion: @escaping ([Track], String) -> ()) {
        
        var tracks = [Track]()
        var curators = [String]()
        var count = 0
        
        for playlist in libraryPlaylists {
            
            GetPlaylist().execute(snapshot: playlist,
                                  authManager: authManager) { playlist, error in
                
                if let p = playlist {
                    tracks.append(contentsOf: p.tracks)
                    curators.append(p.curator)
                }
                
                count += 1
                if count == libraryPlaylists.count {
                    let newCurator = Set(curators).joined(separator: "/")
                    completion(tracks, newCurator)
                }
            }
        }
    }
    
}
