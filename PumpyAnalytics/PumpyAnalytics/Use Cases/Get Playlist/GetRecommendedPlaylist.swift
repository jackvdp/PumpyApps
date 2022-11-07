//
//  GetRecommendedPlaylist.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 20/06/2022.
//

import Foundation

class GetRecommendedPlaylist {
    
    func execute(snapshot: PlaylistSnapshot,
                 trackIDs: [String],
                 authManager: AuthorisationManager,
                 completion: @escaping (RecommendedPlaylist?, ErrorMessage?) -> ()) {
        
        let trackChunks = trackIDs.chunks(50)
        let count = trackChunks.count
        var counter = 0
        
        var tracksRecieved = [Track]()
        
        for chunk in trackChunks {
            SpotifyTracksGateway().run(trackIDs: chunk, authManager: authManager) { tracks, error in
                counter += 1
                tracksRecieved.append(contentsOf: tracks)
                
                if count == counter {
                    
                    let playlist = RecommendedPlaylist(name: snapshot.name,
                                                       tracks: tracksRecieved,
                                                       artworkURL: snapshot.artworkURL,
                                                       description: snapshot.shortDescription, shortDescription: snapshot.shortDescription,
                                                       authManager: authManager,
                                                       sourceID: snapshot.sourceID)
                    
                    completion(playlist, nil)
                    return
                }
            }
        }
        
    }
    
}
