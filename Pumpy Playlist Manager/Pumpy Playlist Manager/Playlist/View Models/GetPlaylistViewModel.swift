//
//  PlaylistViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/02/2022.
//

import Foundation
import SwiftUI
import PumpyAnalytics

class GetPlaylistViewModel: ObservableObject {

    let libraryPlaylist: PlaylistSnapshot
    let authManager: AuthorisationManager
    @Published var playlistRecieved: Playlist?
    @Published var showError = false
    @Published var isSearching = false
    @Published var errorMessage: ErrorMessage = ErrorMessage("Error", "") {
        didSet {
            showError.toggle()
        }
    }

    init(libraryPlaylist: PlaylistSnapshot, authManager: AuthorisationManager) {
        self.libraryPlaylist = libraryPlaylist
        self.authManager = authManager
        getPlaylist()
    }
    
    private func getPlaylist() {
        isSearching = true
        
        PlaylistController().get(libraryPlaylist: libraryPlaylist, authManager: authManager) { playlist, error in
            DispatchQueue.main.async {
                self.isSearching = false
                if let e = error {
                    self.errorMessage = e
                }
                if let p = playlist {
                    self.playlistRecieved = p
                }
            }
        }
    }

}

