//
//  MergeManager.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/06/2022.
//

import Foundation
import PumpyAnalytics

class CreateManager: ObservableObject {
    
    @Published var playlistsToMegre = [PlaylistSnapshot]()
    @Published var tracksToCreate = [Track]()
    
    func addRemoveFromPlaylistsToMix(_ playlist: PlaylistSnapshot) {
        if playlistsToMegre.contains(playlist) {
            playlistsToMegre.removeAll(where: { $0 == playlist})
        } else {
            playlistsToMegre.append(playlist)
        }
    }
    
    func addRemoveFromTracksToCreate(_ track: Track) {
        if tracksToCreate.contains(track) {
            tracksToCreate.removeAll(where: { $0 == track})
        } else {
            tracksToCreate.append(track)
        }
        
        cleanUp()
    }
    
    func addRemoveManyFromTracksToCreate(_ tracks: [Track]) {
        if tracksAreInPlace(tracks) {
            tracksToCreate.removeAll(where: { tracks.contains($0 )})
        } else {
            tracksToCreate.append(contentsOf: tracks)
        }
        
        cleanUp()
    }
    
    private func cleanUp() {
        while tracksToCreate.count > 5 {
            tracksToCreate.removeFirst()
        }
    }
    
    func tracksAreInPlace(_ tracks: [Track]) -> Bool {
        for track in tracks {
            if !tracksToCreate.contains(track) {
                return false
            }
        }
        return true
    }
}
