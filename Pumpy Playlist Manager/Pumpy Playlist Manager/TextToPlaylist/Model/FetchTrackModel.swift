//
//  FetchTrackModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/11/2022.
//

import Foundation
import PumpyAnalytics

class FetchTracks {
    
    private let tracks: [(String, Track?)]
    private let searchController = SearchController()
    private let total: Int
    private var count = 0

    init(tracks: [(String, Track?)]) {
        self.tracks = tracks
        self.total = tracks.count
    }
    
    func fetchNewTrack(_ track: (String, Track?),
                       authManager: AuthorisationManager,
                       completion: @escaping ((String, Track?)) -> ()) {
        
        searchController.searchAMTracks(track.0, limit: 1, authManager: authManager) { [weak self] amTracks, error in
            guard let self = self else { return }
            if let error { print(error) }
            
            if let amTrack = amTracks.first {
                completion((track.0, amTrack))
            }
            
            self.count += 1
            guard self.count < self.total else { return }
            
            self.fetchNewTrack(self.tracks[self.count],
                               authManager: authManager,
                               completion: completion)
        }
    }
    
}
