//
//  GetCustomPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/03/2022.
//

import Foundation

class GetCustomPlaylist {
    
    let authManager: AuthorisationManager
    let libraryPlaylist: PlaylistSnapshot
    var tracksAnalysed = 0
    
    init(libraryPlaylist: PlaylistSnapshot, authManager: AuthorisationManager) {
        self.authManager = authManager
        self.libraryPlaylist = libraryPlaylist
    }
    
    func execute(logic: CustomPlaylistLogic, completion: @escaping (Playlist?, ErrorMessage?) -> ()) {
        
        tracksAnalysed = 0
        GetTracksFromManyPlaylists().execute(libraryPlaylists: logic.snapshots, authManager: authManager) { tracks, curator in
                        
            var count = 0
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                count += 1
                if tracks.count <= self.tracksAnalysed || count == 10 {
                    timer.invalidate()
                    
                    let analysedTracks = FeaturesHelper.getAnalysedTracks(tracks: tracks)
                    
                    print("\(tracks.count) || \(analysedTracks.count)")
                    
                    let newPlaylist = self.createFromLibraryPlaylist(analysedTracks: analysedTracks,
                                                                     curator: curator,
                                                                     libraryPlaylist: self.libraryPlaylist,
                                                                     authManager: self.authManager)
                    
                    completion(newPlaylist, nil)
                }
            }
        }
    }
    
    private func createFromLibraryPlaylist(analysedTracks: [Track],
                                           curator: String,
                                   libraryPlaylist: PlaylistSnapshot,
                                   authManager: AuthorisationManager) -> CustomPlaylist {
        
        var logic = CustomPlaylistLogic(snapshots: [], index: 0, divideBy: .one, sortBy: .bpm)
        switch libraryPlaylist.type {
        case.custom(let playlistLogic):
            logic = playlistLogic
        default:
            break
        }
        
        let sortedTracks = SortPlaylistModel(sortBy: logic.sortBy, tracks: analysedTracks, ascending: false).sortTracks()
        let playlistsTracks = sortedTracks.split(into: logic.divideBy.rawValue)
        
        let selectedTracks = playlistsTracks[logic.index < logic.divideBy.rawValue ? logic.index : 0]
        
        return CustomPlaylist(name: libraryPlaylist.name,
                              curator: curator,
                              tracks: selectedTracks,
                              artworkURL: nil,
                              description: nil,
                              shortDescription: nil,
                              logic: logic,
                              authManager: authManager,
                              sourceID: libraryPlaylist.sourceID)
    }
}
