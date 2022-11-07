//
//  PlaylistViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/02/2022.
//

import Foundation
import SwiftUI
import PumpyAnalytics

class PlaylistViewModel: FilterableViewModel, PlayableViewModel {
    var controller: SavedPlaylistController
    let oldSnapshot: PlaylistSnapshot?
    
    init(_ playlist: Playlist,
         snapshot: PlaylistSnapshot?,
         controller: SavedPlaylistController) {
        self.oldSnapshot = snapshot
        self.controller = controller
        super.init(playlist)
        playlist.getTracksData()
        checkNeedToUpdatePlaylist()
    }
    
    // MARK: - Playlist management
    
    func checkNeedToUpdatePlaylist() {
        guard let oldSnapshot = oldSnapshot else { return }

        if playlist.snapshot != oldSnapshot {
            controller.updateSnapshot(oldSnapshot: oldSnapshot, newSnapshot: playlist.snapshot)
        }
    }
    
    func getCorrectSnapshot() -> PlaylistSnapshot {
        
        if let snapshot = oldSnapshot {
            return snapshot
        } else {
            return playlist.snapshot
        }
    }
    
    func deleteTracks(selectedTracks: Set<Track>) {
        playlist.tracks.removeAll(where: { selectedTracks.contains($0) })
    }
}
