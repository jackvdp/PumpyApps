//
//  GetSpotifyTrack.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 14/04/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetSpotifyItem {
    
    let gateway = SpotifyTrackAPI()
    
    func forPlaylistFromISRC(tracks: [Track], authManager: AuthorisationManager) async {
        let unmatchedTracks = getTracksWithoutSpotItem(tracks: tracks)
        if unmatchedTracks.isEmpty { return }
        
        await unmatchedTracks.asyncForEach { [weak self] track in
            guard let self, let isrc = track.isrc else { return }
            if let item = await self.gateway.getSpotifyTrackFromISRC(isrc: isrc, authManager: authManager) {
                DispatchQueue.main.async { track.spotifyItem = item }
            }
        }
    }
    
    func forPlaylistFromSpotID(tracks: [Track], authManager: AuthorisationManager) async {
        let tracksWithIdNoItem = tracks.filter { $0.spotifyItem != nil && $0.spotifyItem?.year == nil }
        guard tracksWithIdNoItem.isNotEmpty else { return }
        let chunks = tracksWithIdNoItem.chunks(50)
        
        await chunks.asyncForEach { chunk in
            let ids = chunk.compactMap { $0.spotifyItem?.id }
            let json = await gateway.getSpotifyTracksFromIdPack(ids: ids, authManager: authManager)
            guard let json = json else { return }
            let items = SpotifyItemParser().parseForSpotifyItemsFromTracksAPI(json)
            for track in chunk {
                items.filter { $0.id == track.spotifyItem?.id }.forEach { item in
                    DispatchQueue.main.async { track.spotifyItem = item}
                }
            }
        }
    }
    
    // MARK: Helpers
    
    func getTracksWithSpotItem(tracks: [Track]) -> [Track] {
        tracks.filter { track in
            track.spotifyItem != nil
        }
    }
    
    func getTracksWithoutSpotItem(tracks: [Track]) -> [Track] {
        tracks.filter { track in
            track.spotifyItem == nil
        }
    }
}

extension Sequence {
    /// Will do each task sequentially
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
