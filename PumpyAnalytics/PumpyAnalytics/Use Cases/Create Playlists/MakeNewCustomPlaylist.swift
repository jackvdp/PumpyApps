//
//  MakeNewPlaylist.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 26/05/2022.
//

import Foundation

class MakeNewCustomPlaylist {
    
    func execute(name: String,
                 curator: String,
                 tracks: [Track],
                 logic: CustomPlaylistLogic,
                 authManager: AuthorisationManager) -> CustomPlaylist {
        
        return CustomPlaylist(name: name,
                              curator: curator,
                       tracks: tracks,
                       artworkURL: nil,
                       description: nil,
                       shortDescription: nil,
                       logic: logic,
                       authManager: authManager,
                       sourceID: UUID().uuidString)
    }
    
    
    
}
