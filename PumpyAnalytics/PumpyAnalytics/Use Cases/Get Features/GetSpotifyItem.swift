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
    
    func forPlaylistFromISRC(tracks: [Track], authManager: AuthorisationManager, completion: @escaping ([Track]) -> () = {_ in }) {
        guard tracks.count > 0 else { completion([]); return }
        let unmatchedTracks = getTracksWithoutSpotItem(tracks: tracks)
        if unmatchedTracks.isEmpty { completion([]); return }
                
        let trackChunks = unmatchedTracks.chunks(50)
        
        for i in 0..<trackChunks.count {
            
            var count = 0
            let total = trackChunks[i].count
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(i * 2)) { [weak self] in
                guard let self else { return }
                
                for track in trackChunks[i] {
                    
                    self.gateway.getSpotifyTrackFromISRC(isrc: track.isrc, authManager: authManager) { item in
                        
                        count += 1
                        if let item = item {
                            track.spotifyItem = item
                        }
                        
                        if count == total {
                            completion(trackChunks[i])
                        }
                    }
                }
            }
        }
        
    }
    
    func forPlaylistFromSpotID(tracks: [Track], authManager: AuthorisationManager) {
        let tracksWithIdNoItem = tracks.filter { $0.spotifyItem != nil && $0.spotifyItem?.year == nil }
        if tracksWithIdNoItem.count == 0 { return }
        let chunks = tracksWithIdNoItem.chunks(50)
        
        for chunk in chunks {
            let ids = chunk.compactMap { $0.spotifyItem?.id }
            gateway.getSpotifyTracksFromIdPack(ids: ids, authManager: authManager) { json in
                if let json = json {
                    let items = SpotifyItemParser().parseForSpotifyItemsFromTracksAPI(json)
                    for track in chunk {
                        if let item = items.first(where: { $0.id == track.spotifyItem?.id }) {
                            track.spotifyItem = item
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Get
    
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
