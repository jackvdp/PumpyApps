//
//  LibraryManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2023.
//

import Foundation
import PumpyAnalytics
import MediaPlayer
import MusicKit

public class LibraryManager: ObservableObject {
    
    public init() {}
    let playlistController = PlaylistController()
    
    /// IDs of playlists currently converting
    @Published var playlistsCurrentlyConverting = [String]()
    /// IDs of playlists recently added
    @Published var playlistsJustAdded = [String]()
    
    func isPlaylistInLibrary(_ playlist: Playlist, playlistManager: any PlaylistProtocol) -> Bool {
        if playlistsJustAdded.contains(playlist.sourceID) {
            // E.g. spotify playlists added just in the session
            // should get a tick, but not always as it will change but it's not synced
            return true
        }
        guard let id = playlist.cloudGlobalID else { return false }
        let playlists = playlistManager.getPlaylists()
        return playlists.contains(where: { $0.cloudGlobalID == id })
    }
    
    func addToLibrary(_ playlist: Playlist, authManager: AuthorisationManager, toastManager: ToastManager) {
        guard !playlistsCurrentlyConverting.contains(playlist.sourceID) else { return }
        playlistsCurrentlyConverting.append(playlist.sourceID)
        
        if let mediaPLaylist = playlist as? MPMediaPlaylist,
           let cloudGlobalID = mediaPLaylist.cloudGlobalID {
            playlistController.addToAppleMusic(
                playlistID: cloudGlobalID,
                authManager: authManager
            ) { [weak self] error in
                self?.handleResponse(error, playlist: playlist, toastManager: toastManager)
            }
        } else if let amPlaylist = playlist as? AMPlaylist {
            playlistController.addToAppleMusic(
                playlistID: amPlaylist.sourceID,
                authManager: authManager
            ) { [weak self] error in
                self?.handleResponse(error, playlist: playlist, toastManager: toastManager)
            }
        } else {
            
            let tracks: [PumpyAnalytics.Track] = playlist.songs.compactMap { song in
                guard let amID = song.amStoreID else { return nil }
                return PumpyAnalytics.Track(
                    title: song.name,
                    artist: song.artistName,
                    album: "",
                    isrc: "",
                    artworkURL: nil,
                    previewUrl: nil,
                    isExplicit: song.isExplicitItem,
                    sourceID: amID,
                    authManager: authManager,
                    appleMusicItem: AppleMusicItem.blankItemWithID(amID),
                    spotifyItem: nil
                )
            }
            
            playlistController.convertToAppleMusic(
                playlistName: playlist.title ?? "Playlist",
                tracks: tracks,
                authManager: authManager
            ) { [weak self] error in
                self?.handleResponse(error, playlist: playlist, toastManager: toastManager)
            }
            
        }
    }
    
    private func handleResponse(_ error: ErrorMessage?, playlist: Playlist, toastManager: ToastManager) {
        playlistsCurrentlyConverting.removeAll(where: { $0 == playlist.sourceID })
        if error != nil {
            toastManager.showLibraryAddedErrorToast = true
        } else {
            playlistsJustAdded.append(playlist.sourceID)
            toastManager.showLibraryAddedToast = true
        }
    }
    
}
