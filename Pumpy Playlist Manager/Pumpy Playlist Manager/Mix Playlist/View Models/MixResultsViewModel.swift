//
//  SortedPlaylistsViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/03/2022.
//

import Foundation
import PumpyAnalytics

class MixResultsViewModel: ObservableObject {
    
    let playlists: [CustomPlaylist]
    @Published var selectedPlaylist: CustomPlaylist
    
    init(playlists: [CustomPlaylist]) {
        self.playlists = playlists
        selectedPlaylist = self.playlists[0]
    }
    
}
