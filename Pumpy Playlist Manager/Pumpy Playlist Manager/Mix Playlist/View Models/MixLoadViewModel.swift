//
//  CreatePlaylistViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/03/2022.
//

import Foundation
import PumpyAnalytics

class MixLoadViewModel: ObservableObject {
    
    let playlists: [PlaylistSnapshot]
    var authManager: AuthorisationManager
    @Published var isSearching = true
    @Published var customPlaylist: CustomPlaylist?
    
    init(playlists: [PlaylistSnapshot], tracks: CustomPlaylist?, authManager: AuthorisationManager) {
        self.playlists = playlists
        self.authManager = authManager
        self.customPlaylist = tracks
        getTracksFromSnapshots()
    }
    
    private func getTracksFromSnapshots() {
        guard customPlaylist == nil else { return }
        
        PlaylistController().merge(name: makePlaylistName(),
                                   libraryPlaylists: playlists,
                                   authManager: authManager) { newPlaylist in
            
            DispatchQueue.main.async {
                self.isSearching = false
                self.customPlaylist = newPlaylist
            }
        }
    }
    
    private func makePlaylistName() -> String {
        return playlists
            .compactMap { $0.name }
            .joined(separator: "/")
    }
}
