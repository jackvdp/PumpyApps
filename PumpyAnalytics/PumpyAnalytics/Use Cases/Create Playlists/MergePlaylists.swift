//
//  MergePlaylists.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 29/07/2022.
//

import Foundation

class MergePlaylists {
    
    func excute(name: String?,
                snapshots: [PlaylistSnapshot],
                authManager: AuthorisationManager,
                completion: @escaping (CustomPlaylist) -> ()) {
        
        GetTracksFromManyPlaylists().execute(libraryPlaylists: snapshots,
                                             authManager: authManager) { tracks, curator in
            
            let playlist = MakeNewCustomPlaylist().execute(name: name ?? self.makeName(snapshots),
                                                     curator: curator,
                                                     tracks: tracks,
                                                     logic: CustomPlaylistLogic(snapshots: snapshots),
                                                     authManager: authManager)
            
            completion(playlist)
                
        }
    }
    
    private func makeName(_ snapshots: [PlaylistSnapshot]) -> String {
        let names = snapshots.compactMap { $0.name }
        return names.joined(separator: "/")
    }
    
}
