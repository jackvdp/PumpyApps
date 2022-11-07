//
//  PlaylistSearchViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/02/2022.
//

import Foundation
import PumpyAnalytics

class PlaylistFindViewModel: SearchViewModel {
    
    @Published var searchTerm = String()
    @Published var libraryPlaylist: PlaylistSnapshot?
    @Published var errorMessage: ErrorMessage = ErrorMessage("Error", "")
    @Published var showError = false
    
    let placeHolderText: String = "Enter playlist URL..."
    
    func clearSearch() {
        searchTerm = String()
    }
    
    func runSearch() {
        libraryPlaylist = nil
        if searchTerm != "" {
            let (playlist, error) = PlaylistController().getSnapshotIDFromURL(playlistURL: searchTerm)
            
            if let error = error {
                errorMessage = error
                self.showError = true
            }
            
            libraryPlaylist = playlist
        }
    }
    
}
