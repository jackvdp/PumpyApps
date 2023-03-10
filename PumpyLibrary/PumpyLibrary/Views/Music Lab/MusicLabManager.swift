//
//  MusicLabManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/03/2023.
//

import Foundation

class MusicLabManager: ObservableObject {
    
    private(set) var seedTracks = [Track]()
    var limit = 50
    
    /// Add new track to seed items. If seed tracks is already at capacity (count of 5), the first item will be removed
    func addTrack(_ track: Track) {
        seedTracks.append(track)
        
        if seedTracks.count > 5 {
            seedTracks.removeFirst()
        }
    }
    
    func removeTrack(at offsets: IndexSet) {
        seedTracks.remove(atOffsets: offsets)
    }
    
}
