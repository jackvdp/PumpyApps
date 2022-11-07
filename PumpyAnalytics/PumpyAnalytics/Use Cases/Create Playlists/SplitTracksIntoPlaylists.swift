//
//  SplitTracksIntoPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 16/03/2022.
//

import Foundation

class SplitTracksIntoPlaylists {
    
    func createNewPlaylists(analysedTracks: [Track],
                            playlistName: String,
                            curator: String,
                            logic: CustomPlaylistLogic,
                            authManager: AuthorisationManager) -> [CustomPlaylist] {
        
        let sortedTracks = SortPlaylistModel(sortBy: logic.sortBy, tracks: analysedTracks, ascending: false).sortTracks()
        let playlistsTracks = sortedTracks.split(into: logic.divideBy.rawValue)
        var playlists = [CustomPlaylist]()
        
        for i in 0..<playlistsTracks.count {
            
            let logic = CustomPlaylistLogic(snapshots: logic.snapshots,
                                            index: i,
                                            divideBy: logic.divideBy,
                                            sortBy: logic.sortBy)
            
            playlists.append(CustomPlaylist(name: makeName(i + 1,
                                                           of: playlistsTracks.count,
                                                           name: playlistName,
                                                           sortBy: logic.sortBy),
                                            curator: curator,
                                            tracks: playlistsTracks[i],
                                            artworkURL: nil,
                                            description: nil,
                                            shortDescription: nil,
                                            logic: logic,
                                            authManager: authManager,
                                            sourceID: UUID().uuidString)
            )
        }
        
        return playlists
    }
    
    private func makeName(_ current: Int, of count: Int, name: String, sortBy: SortTracks) -> String {
        
        var newName = name
        
        if count != 1 {
            newName += " " + current.description + " of " + count.description
        }
        
        if current == 1 && count != 1 && sortBy != .standard {
            newName += " (Most \(sortBy.rawValue))"
        } else if current == count && count != 1 && sortBy != .standard {
            newName += " (Least \(sortBy.rawValue))"
        }
        
        return newName
    }
    
    private func makeCuratorName(playlists: [Playlist]?) -> String {
        if let playlists = playlists {
            return playlists.map { $0.curator }.joined(separator: "/")
        } else {
            return "Custom"
        }
    }
    
}
