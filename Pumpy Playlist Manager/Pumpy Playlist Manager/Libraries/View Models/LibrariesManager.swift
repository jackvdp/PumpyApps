//
//  HomeViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/03/2022.
//

import Foundation
import MusicKit
import PumpyAnalytics

class LibrariesManager: ObservableObject {
    
    @Published var amLibPlaylists = [PlaylistSnapshot]()
    @Published var isSearching = true
        
    func getPlaylistsfromMusicLibrary(authManager: AuthorisationManager) {
        isSearching = true
        amLibPlaylists = []
        
        LibraryPlaylistsController().getAppleMusicLibraryPlaylists(authManager: authManager) { playlists, error in
            if let e = error {
                print(e)
                return
            }
            
            self.isSearching = false
            
            self.amLibPlaylists.append(contentsOf: playlists)
            
        }
    }
    
}
