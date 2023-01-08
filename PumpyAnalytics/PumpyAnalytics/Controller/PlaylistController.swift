//
//  GetPlaylistModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/03/2022.
//

import Foundation

public class PlaylistController {
    
    public init() {}
    
    public func get(libraryPlaylist: PlaylistSnapshot,
                    authManager: AuthorisationManager,
                    completion: @escaping (Playlist?, ErrorMessage?) -> ()) {
        
        GetPlaylist().execute(snapshot: libraryPlaylist,
                              authManager: authManager,
                              completion: completion)
        
    }
    
    public func merge(name: String?,
                      libraryPlaylists: [PlaylistSnapshot],
                      authManager: AuthorisationManager,
                      completion: @escaping (CustomPlaylist) -> ()) {
        
        MergePlaylists().excute(name: name,
                                snapshots: libraryPlaylists,
                                authManager: authManager,
                                completion: completion)
    }
    
    public func split(analysedTracks: [Track],
                      playlistName: String,
                      curator: String?,
                      logic: CustomPlaylistLogic,
                      authManager: AuthorisationManager) -> [CustomPlaylist] {
        
        return SplitTracksIntoPlaylists()
            .createNewPlaylists(analysedTracks: analysedTracks,
                                playlistName: playlistName,
                                curator: curator ?? "Custom",
                                logic: logic,
                                authManager: authManager)
    }
    
    public func convertToAppleMusic(playlistName: String,
                                    tracks: [Track],
                                    authManager: AuthorisationManager,
                                    completion: @escaping (ErrorMessage?) -> ()) {
        
        ConvertPlaylistToAppleMusic()
            .execute(playlistName: playlistName,
                     tracks: tracks,
                     authManager: authManager,
                     completion: completion)
        
    }
    
    public func convertToSpotify(playlistName: String,
                                 tracks: [Track],
                                 authManager: AuthorisationManager,
                                 completion: @escaping (Bool, String?) -> ()) {
        
        
    }

    public func getSnapshotIDFromURL(playlistURL: String) -> (PlaylistSnapshot?, ErrorMessage?) {
        return GetIDFromURL().execute(playlistURL)
    }
    
    public func createFromSuggestions(seeding: PlaylistSeeding,
                                      authManager: AuthorisationManager,
                                      completion: @escaping (Playlist?, ErrorMessage?) -> ()) {
        
        CreatePlaylistFromSeeding().execute(seeding: seeding,
                                            authManager: authManager,
                                            completion: completion)
    }
    
}
