//
//  GetMusicItem.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 20/04/2022.
//

import Foundation

class GetMusicItem {
    
    func get(from provider: PlaylistType, for tracks: [Track], authManager: AuthorisationManager) {
        switch provider {
        case .am:
            makeMusicStoreItems(tracks: tracks)
        default:
            MatchToAM().execute(tracks: tracks, authManager: authManager)
        }
    }
    
    private func makeMusicStoreItems(tracks: [Track]) {
        tracks.forEach { track in
            guard let isrc = track.isrc else { return }
            track.appleMusicItem = AppleMusicItem(isrc: isrc,
                                                  id: track.sourceID,
                                                  name: track.title,
                                                  artistName: track.artist,
                                                  artworkURL: track.artworkURL,
                                                  genres: [],
                                                  type: .track)
        }
    }
}
