//
//  UpdatePlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/06/2022.
//

import Foundation
import PumpyAnalytics

class UpdatePlaylist {

    func execute(oldSnapshot: PlaylistSnapshot, newSnapshot: PlaylistSnapshot, for username: String) {
        PlaylistDBGateway(username: username)
            .updateSnapshot(oldSnapshot: oldSnapshot, newSnapshot: newSnapshot)
    }
    
}
