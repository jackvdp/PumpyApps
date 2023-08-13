//
//  AnalyseMediaPlayerTrack.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 05/11/2022.
//

import Foundation
import MusicKit

class AnalyseMediaPlayerTracks {
    
    private let getSpotifyItemUseCase = GetAudioFeaturesAndSpotifyItem()
    
    func execute(tracks: [Track], authManager: AuthorisationManager) async {
        await getISRCsOfAMTracks(tracks: tracks, authManager: authManager)
        await getSpotifyItemUseCase.forPlaylist(tracks: tracks, authManager: authManager)
    }
    
    private func getISRCsOfAMTracks(tracks: [Track], authManager: AuthorisationManager) async {
        let musicItemIDs = tracks.map { MusicItemID($0.sourceID) }
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, memberOf: musicItemIDs)
        do {
            let response = try await request.response()
            response.items.forEach { song in
                guard let isrc = song.isrc else { return }
                tracks.filter { song.id.rawValue == $0.sourceID}.forEach { track in
                    let amItem = AppleMusicItem(
                        isrc: isrc,
                        id: song.id.rawValue,
                        name: song.title,
                        artistName: song.artistName,
                        genres: song.genreNames,
                        type: .track
                    )
                    track.appleMusicItem = amItem
                    track.isrc = isrc
                }
            }
        } catch {
            print("Error fetching isrcs of AM Tracks", error)
        }
    }
    
}
