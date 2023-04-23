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
                                             seeding: AttributeSeeding(maxDanceability: nil, minDanceability: nil, maxEnergy: nil, minEnergy: nil, maxPopularity: nil, minPopularity: nil, maxBPM: nil, minBPM: nil, maxHappiness: nil, minHappiness: nil, maxLoudness: nil, minLoudness: nil, maxInstrumnetalness: nil, minInstrumnetalness: nil, maxAcoustic: nil, minAcoustic: nil))
    
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
