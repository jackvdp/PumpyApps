//
//  LibraryManager.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import Foundation
import Firebase
import CodableFirebase
import PumpyAnalytics

public class SavedPlaylistController: ObservableObject {
    
    @Published public var savedPlaylists = [PlaylistSnapshot]()
    var listener: ListenerRegistration?
    var username: String?
    
    deinit {
        signOut()
    }
    
    public func signIn(username: String) {
        self.username = username
        downloadPlaylists()
    }
    
    public func signOut() {
        username = nil
        listener?.remove()
    }
    
    public func downloadPlaylists() {
        guard let username = username else { return }

        listener = RetrievePlaylists().execute(username: username) { playlists in
            self.savedPlaylists = playlists
        }
    }
    
    public func addRemovePlaylistFromLibrary(_ playlist: PlaylistSnapshot) {
        guard let username = username else { return }
        AddRemovePlaylist().execute(playlist, db: savedPlaylists, for: username)
    }
    
    public func updateSnapshot(oldSnapshot: PlaylistSnapshot, newSnapshot: PlaylistSnapshot) {
        guard let username = username else { return }
        
        if savedPlaylists.contains(oldSnapshot) {
            UpdatePlaylist().execute(oldSnapshot: oldSnapshot, newSnapshot: newSnapshot, for: username)
        }
    }
    
    public func isInLibrary(_ playlist: PlaylistSnapshot) -> Bool {
        CheckPlaylistInDB().execute(for: playlist, db: savedPlaylists)
    }
    
} 
