//
//  GetPlaylistModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/03/2022.
//

import Foundation

public class PlaylistController {
    
    public init() {}
    
    // MARK: GET
    
    private let getUseCase = GetPlaylist()
    
    /// Get a playlist (e.g. Spotify, AM, SYB, Recommended) from a given snapshot
    public func get(libraryPlaylist: PlaylistSnapshot,
                    authManager: AuthorisationManager,
                    completion: @escaping (Playlist?, ErrorMessage?) -> ()) {
        getUseCase.execute(snapshot: libraryPlaylist,
                           authManager: authManager,
                           completion: completion)
    }
    
    // MARK: MERGE
    
    private let mergeUseCase = MergePlaylists()
    
    /// Merge a number of playlists together into one playlist
    public func merge(name: String?,
                      libraryPlaylists: [PlaylistSnapshot],
                      authManager: AuthorisationManager,
                      completion: @escaping (CustomPlaylist) -> ()) {
        mergeUseCase.excute(name: name,
                            snapshots: libraryPlaylists,
                            authManager: authManager,
                            completion: completion)
    }
    
    // MARK: SPLIT
    
    /// Split a playlist into a number of playlists according to defined logic
    public func split(analysedTracks: [Track],
                      playlistName: String,
                      curator: String?,
                      logic: CustomPlaylistLogic,
                      authManager: AuthorisationManager) -> [CustomPlaylist] {
        SplitTracksIntoPlaylists()
            .createNewPlaylists(analysedTracks: analysedTracks,
                                playlistName: playlistName,
                                curator: curator ?? "Custom",
                                logic: logic,
                                authManager: authManager)
    }
    
    // MARK: - Add or Convert playlists to platform
    
    private let addToAMUseCase = AddToAppleMusicLibrary()
    
    /// Adds an Apple Music playlist tyo user's library
    public func addToAppleMusic(playlistID: String,
                                authManager: AuthorisationManager,
                                completion: @escaping (ErrorMessage?) -> ()) {
        addToAMUseCase.execute(
            playlistID: playlistID,
            authManager: authManager,
            completion: completion
        )
    }
    
    private let convertToAMUseCase = ConvertPlaylistToAppleMusic()
    
    public func convertToAppleMusic(playlistName: String,
                                    tracks: [Track],
                                    authManager: AuthorisationManager,
                                    completion: @escaping (ErrorMessage?) -> ()) {
        convertToAMUseCase.execute(
            playlistName: playlistName,
            tracks: tracks,
            authManager: authManager,
            completion: completion
        )
    }
    
    public func convertToSpotify(playlistName: String,
                                 tracks: [Track],
                                 authManager: AuthorisationManager,
                                 completion: @escaping (Bool, String?) -> ()) {
        fatalError("Not implemented yet")
    }

    public func getSnapshotIDFromURL(playlistURL: String) -> (PlaylistSnapshot?, ErrorMessage?) {
        return GetIDFromURL().execute(playlistURL)
    }
    
    // MARK: - Recommended Playlist
    
    private let createFromSeedingUseCase = CreatePlaylistFromSeeding()
    
    /// Make playlist from seeding using Spotify's `/getRecommendations` endpoint
    /// - Parameters:
    ///   - initialTracks: Tracks to be placed at the beginning of new playlist
    ///   - seeding: Tunable attributes for the returnign playlist
    ///   - playlistName: The name of the new playlist
    ///   - authManager: Authrosation manager
    ///   - completion: Returns either a playlist or an error
    public func createFromSuggestions(initialTracks: [Track],
                                      seeding: PlaylistSeeding,
                                      playlistName: String,
                                      artworkURL: String?,
                                      authManager: AuthorisationManager,
                                      completion: @escaping (RecommendedPlaylist?, ErrorMessage?) -> ()) {
        
        createFromSeedingUseCase.execute(initialTracks: initialTracks,
                                         seeding: seeding,
                                         playlistName: playlistName,
                                         artworkURL: artworkURL,
                                         authManager: authManager,
                                         completion: completion)
    }
    
}
