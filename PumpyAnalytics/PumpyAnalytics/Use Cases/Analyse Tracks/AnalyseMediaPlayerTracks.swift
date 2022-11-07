//
//  AnalyseMediaPlayerTrack.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 05/11/2022.
//

import Foundation
import MusicKit

class AnalyseMediaPlayerTracks {
    
    func execute(ids: [String], authManager: AuthorisationManager, completion: @escaping ([Track])->()) {
        Task {
            let tracks = await getISRCsOfAMTracks(ids: ids, authManager: authManager)
            AnalyseTracks().execute(tracks: tracks,
                                    authManager: authManager,
                                    completion: completion)
        }
    }
    
    private func getISRCsOfAMTracks(ids: [String], authManager: AuthorisationManager) async -> [Track] {
        let musicItemIDs = ids.map { MusicItemID($0) }
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, memberOf: musicItemIDs)
        do {
            let response = try await request.response()
            let tracks: [Track] = response.items.compactMap { song in
                guard let isrc = song.isrc else { return nil }
                return Track(title: song.title,
                             artist: song.artistName,
                             album: song.albumTitle ?? "",
                             isrc: isrc,
                             artworkURL: nil,
                             previewUrl: nil,
                             isExplicit: false,
                             sourceID: song.id.rawValue,
                             authManager: authManager,
                             appleMusicItem: AppleMusicItem(isrc: isrc,
                                                            id: song.id.rawValue,
                                                            name: song.title,
                                                            artistName: song.artistName,
                                                            genres: song.genreNames,
                                                            type: .track))
            }
            return tracks
        } catch {
            print(error)
            return []
        }
    }
    
}
