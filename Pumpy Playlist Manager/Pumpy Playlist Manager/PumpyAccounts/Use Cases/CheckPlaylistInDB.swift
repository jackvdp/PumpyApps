//
//  CheckPlaylistInDB.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/06/2022.
//

import Foundation
import PumpyAnalytics

class CheckPlaylistInDB {
    
    func execute(for playlist: PlaylistSnapshot, db: [PlaylistSnapshot]) -> Bool {
        db.filter { playlist.sourceID == $0.sourceID }.count > 0
    }
    
}
