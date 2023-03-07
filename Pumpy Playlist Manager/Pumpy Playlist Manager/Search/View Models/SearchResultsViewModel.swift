//
//  SearchResultsViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 14/06/2022.
//

import Foundation
import PumpyAnalytics

class SearchResultsViewModel: ObservableObject {
    
    @Published var sybPLaylists = [PlaylistSnapshot]()
    @Published var sybSearching = true
    
    @Published var amPLaylists = [PlaylistSnapshot]()
    @Published var amSearching = true
    
    @Published var spotifyPLaylists = [PlaylistSnapshot]()
    @Published var spotifySearching = true
    
    @Published var artistStation: PlaylistSnapshot?
    @Published var artistStationSearching = true
    
    @Published var errorMessage = ErrorMessage("Error", "")
    @Published var showError = false
    
    func runSearch(_ searchTerm: String, _ authManager: AuthorisationManager) {
        resetSearch()
        if searchTerm != "" {
            runSYBSearch(searchTerm)
            runAMSearch(searchTerm, authManager)
            runSpotifySearch(searchTerm, authManager)
            runArtistSearch(searchTerm)
        }
    }
    
    private func resetSearch() {
        spotifySearching = true
        amSearching = true
        sybSearching = true
        artistStationSearching = true
        spotifyPLaylists = []
        amPLaylists = []
        sybPLaylists = []
        artistStation = nil
    }
    
    private func runSYBSearch(_ searchTerm: String) {
        
        SearchController().searchSYB(searchTerm) { playlists, error in
            self.sybSearching = false
            if let error = error {
                self.errorMessage = error
                self.showError.toggle()
                return
            }
            
            guard let playlists = playlists else { return }
            
            self.sybPLaylists = playlists
        }
    }
    
    private func runAMSearch(_ searchTerm: String, _ authManager: AuthorisationManager) {
        SearchController().searchAppleMusic(searchTerm, getNext: true, authManager: authManager) { playlists, error in
            self.amSearching = false
            if let error = error {
                self.errorMessage = error
                self.showError.toggle()
                return
            }
            
            guard let playlists = playlists else { return }
            
            self.amPLaylists.append(contentsOf: playlists)
        }
    }
    
    private func runSpotifySearch(_ searchTerm: String, _ authManager: AuthorisationManager) {
        SearchController().searchSpotify(searchTerm, authManager: authManager) { playlists, error in
            self.spotifySearching = false
            if let error = error {
                self.errorMessage = error
                self.showError.toggle()
                return
            }
            
            guard let playlists = playlists else { return }

            self.spotifyPLaylists = playlists
            
        }
    }
    
    private func runArtistSearch(_ searchTerm: String) {
        
        SearchController().searchArtistStation(searchTerm) { playlist, error in
            self.artistStationSearching = false
            if let error = error {
                self.errorMessage = error
                self.showError.toggle()
                return
            }
            
            guard let playlist = playlist else { return }
            
            self.artistStation = playlist
        }
    }
    
}
