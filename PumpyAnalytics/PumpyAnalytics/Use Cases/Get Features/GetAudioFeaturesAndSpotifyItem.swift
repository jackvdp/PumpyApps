//
//  GetPlaylistTrackFeatures.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/03/2022.
//

import Foundation
import PumpyShared

class GetAudioFeaturesAndSpotifyItem {
    
    private let getSpotifyItemUseCase = GetSpotifyItem()
    private let featuresGateway = SpotifyFeaturesAPI()
    
    func forPlaylist(tracks: [Track], authManager: AuthorisationManager) async {
        // Get Unanalysed tracks that are not currently being analysed
        let unAnalysedTracks = FeaturesHelper.getUnAnalysedTracks(tracks: tracks).filter { !$0.inProgress.analysing }
        guard unAnalysedTracks.isNotEmpty else { return }
        
        DispatchQueue.main.async { unAnalysedTracks.forEach {  $0.inProgress.analysing = true } }
        
        // Split matched tracks from unmatched tracks
        let matchedTracks = unAnalysedTracks.filter { $0.spotifyItem != nil }
        let unMatchedTracks = unAnalysedTracks.filter { $0.spotifyItem == nil }

        // Get spotify items for unmatchedTracks
        await getSpotifyItemUseCase.forPlaylistFromISRC(tracks: unMatchedTracks, authManager: authManager)
        
        // Get features for all tracks
        await getFeatures(tracks: unAnalysedTracks, authManager: authManager)
        
        // Get Spotify item for only partial matched tracks (SYB tracks)
        await getSpotifyItemUseCase.forPlaylistFromSpotID(tracks: matchedTracks, authManager: authManager)
    }
    
    private func getFeatures(tracks: [Track], authManager: AuthorisationManager) async {
        
        // Those tracks without id cannot be analysed
        let tracksNotAnalysing = tracks.filter { $0.spotifyItem?.id == nil }
        DispatchQueue.main.async { tracksNotAnalysing.forEach { $0.inProgress.analysing = false } }
        
        let tracksAnalysing = tracks.filter { $0.spotifyItem?.id != nil }
        
        let chunks = tracksAnalysing.chunks(100)
        
        await chunks.asyncForEach { group in
            
            let ids = group.compactMap { $0.spotifyItem?.id }
            
            let features = await featuresGateway.getManyAudioFeaturesFromSpotifyID(ids: ids, authManager: authManager)
            
            for track in tracks {
                features.filter { $0.id == track.spotifyItem?.id }.forEach { feature in
                    DispatchQueue.main.async {
                        track.audioFeatures = feature
                    }
                }
            }
            
            DispatchQueue.main.async { chunks.forEach { $0.forEach { $0.inProgress.analysing = false }} }
        }
    }
    
}
