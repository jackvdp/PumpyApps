//
//  GetPlaylistTrackFeatures.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/03/2022.
//

import Foundation

class GetAudioFeaturesAndSpotifyItem {
    
    func forPlaylist(tracks: [Track], authManager: AuthorisationManager, completion: @escaping () -> () = {}) {
        // Get Unanalysed Tracks
        let unAnalysedTracks = FeaturesHelper.getUnAnalysedTracks(tracks: tracks)
        
        if unAnalysedTracks.isEmpty {
            completion();
            return
        }
        
        unAnalysedTracks.forEach { $0.inProgress.analysing = true }
        
        // Split matched tracks from unmatched tracks
        let matchedTracks = unAnalysedTracks.filter { $0.spotifyItem != nil }
        let unMatchedTracks = unAnalysedTracks.filter { $0.spotifyItem == nil }

        // Get features for unmatchedTracks
        GetSpotifyItem().forPlaylistFromISRC(tracks: unMatchedTracks, authManager: authManager) { tracks in
            self.getFeatures(tracks: tracks, authManager: authManager, completion: completion)
        }
        
        // Get features for matchedTracks
        getFeatures(tracks: matchedTracks, authManager: authManager, completion: completion)
        
        // Get Spotify item for only partial matched tracks (SYB tracks)
        GetSpotifyItem().forPlaylistFromSpotID(tracks: matchedTracks, authManager: authManager)
    }
    
    private func getFeatures(tracks: [Track], authManager: AuthorisationManager, completion: @escaping () -> ()) {
        
        let tracksNotAnalysing = tracks.filter { $0.spotifyItem?.id == nil }
        tracksNotAnalysing.forEach { $0.inProgress.analysing = false }
        
        let tracksAnalysing = tracks.filter { $0.spotifyItem?.id != nil }
        
        let chunks = tracksAnalysing.chunks(100)
        let pages = chunks.count
        var pageCount = 0
        
        chunks.forEach { page in
            
            let ids = page.compactMap { $0.spotifyItem?.id }
            
            SpotifyFeaturesAPI(authManager).getManyAudioFeaturesFromSpotifyID(ids: ids) { features in

                pageCount += 1
                
                for track in tracks {
                    if let feature = features.first(where: { $0.id == track.spotifyItem?.id }) {
                        DispatchQueue.main.async {
                            track.audioFeatures = feature
                            if track == tracks.last && pageCount == pages {
                                completion()
                                chunks.forEach { $0.forEach { $0.inProgress.analysing = false }}
                            }
                        }
                    }
                }
            }
        }
    }
    
}
