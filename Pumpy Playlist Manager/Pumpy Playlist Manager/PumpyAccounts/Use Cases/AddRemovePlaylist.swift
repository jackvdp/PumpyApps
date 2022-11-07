//
//  AddPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/06/2022.
//

import Foundation
import PumpyAnalytics

class AddRemovePlaylist {
    
    func execute(_ playlist: PlaylistSnapshot, db: [PlaylistSnapshot], for username: String) {
        if db.contains(playlist) {
            PlaylistDBGateway(username: username).removePlaylistFromLibrary(playlist: playlist)
        } else {
            PlaylistDBGateway(username: username).addPlaylistToLibrary(playlist: playlist)
        }
    }
    
}
