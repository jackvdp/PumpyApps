//
//  CreateStagingViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 23/06/2022.
//

import Foundation
import PumpyAnalytics

class CreateStagingViewModel: ObservableObject {
    
    let nav: CreateNavigationManager
    @Published var seeding = PlaylistSeeding(trackIDs: [],
                                             artistIDs: [],
                                             genres: [],
                                             playlistSize: 100,
                                             seeding: CustomSeeding(
                                                maxDanceability: 0.5,
                                                minDanceability: 0.2,
                                                maxEnergy: 0.5,
                                                minEnergy: 0.2,
                                                maxPopularity: 20,
                                                minPopularity: 100,
                                                maxBPM: 250,
                                                minBPM: 0,
                                                maxHappiness: 0.5,
                                                minHappiness: 0.2,
                                                maxLoudness: 0,
                                                minLoudness: -20,
                                                maxSpeechiness: 0.5,
                                                minSpeechiness: 0.2,
                                                maxAcoustic: 0.5,
                                                minAcoustic: 0.2
                                            )
    )
    
    init(nav: CreateNavigationManager) {
        self.nav = nav
    }
    
    func makeRequest(authManager: AuthorisationManager, tracks: [Track]) {
        let trackIDs = tracks.compactMap { $0.spotifyItem?.id }
        seeding.trackIDs = trackIDs
        
        PlaylistController().createFromSuggestions(seeding: seeding,
                                                           authManager: authManager) { playlist, error in
            
            guard let playlist = playlist else {
                return
            }

            
            self.nav.currentPage = .createdPlaylist(playlist)
            
        }
    }
    
}
