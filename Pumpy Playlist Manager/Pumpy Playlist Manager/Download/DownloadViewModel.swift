//
//  DownloadViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 26/03/2022.
//

import Foundation
import ToastUI
import SwiftUI
import PumpyAnalytics

class DownloadViewModel: ObservableObject {
    
    @Published var playlistName: String
    @Published var tracks: [Track]
    @Published var showAlert = false
    @Published var converting = false
    @Published var alertMessage = String()
    
    var authManager: AuthorisationManager
    
    @Published var matchedTracks = [Track]()
    @Published var unMatchedTracks = [Track]()
    
    init(playlistName: String?, tracks: [Track], authManager: AuthorisationManager) {
        self.playlistName = playlistName ?? "Untitled"
        self.tracks = tracks
        self.authManager = authManager
        subscribeToUpdate()
        respondToMatch()
    }
    
    func downloadPlaylist(completion: @escaping () -> ()) {
        
        guard playlistName != String() else {
            self.alertMessage = "Please provide a name for the playlist."
            self.showAlert = true
            return
        }
        
        converting = true
        PlaylistController().convertToAppleMusic(playlistName: playlistName,
                                                 tracks: tracks,
                                                 authManager: authManager) { errorMessage in

            self.converting = false
            if errorMessage == nil {
                self.alertMessage = "Succesffully converted playlist \(self.playlistName) to Apple Music."
                self.showAlert = true
                completion()
            } else {
                self.alertMessage = "\(errorMessage?.message ?? "Unknown"). Failed to convert playlist \(self.playlistName) to Apple Music. Please try again later."
                self.showAlert = true
            }
        }
    }
    
    func subscribeToUpdate() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(respondToMatch), name: .TracksMatchedToAppleMusic, object: nil)
    }
    
    @objc func respondToMatch() {
        matchedTracks = tracks.filter { $0.appleMusicItem != nil}
        unMatchedTracks = tracks.filter { $0.appleMusicItem == nil}
    }
}
