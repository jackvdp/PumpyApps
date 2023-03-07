//
//  CatalogSearchViewModel.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 14/09/2022.
//

import Foundation
import PumpyAnalytics

class CatalogSearchViewModel: ObservableObject {
    
    @Published var pageState = PageState.loading
    private let controller = SearchController()
    var lastSearchTerm = String()
    
    func runSearch(term: String, authManager: AuthorisationManager) {
        lastSearchTerm = term
        var amSnapshots = [PlaylistSnapshot]()
        var spotifySnapshots = [PlaylistSnapshot]()
        var sybSnapshots = [PlaylistSnapshot]()
        var searchedTracks = [ConstructedTrack]()
        var done = 0
        
        // MARK: - AM Playlists
        controller.searchAppleMusic(term,
                                    getNext: false,
                                    authManager: authManager) { [weak self] snapshots, error in
            done += 1
            
            guard let self = self else { return }
            guard let snapshots = snapshots else {
                print("Error conducting search \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            amSnapshots = snapshots
            
            if done == 4 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          tracks: searchedTracks)
            }
        }
        
        // MARK: - AM Tracks
        controller.searchAMTracks(term, authManager: authManager) { [weak self] tracks, error in
            done += 1
            
            guard let self = self else { return }
            if let e = error {
                print("Error conducting search \(e.message)")
                self.pageState = .failed
                return
            }
            searchedTracks = tracks.compactMap { track in
                ConstructedTrack(title: track.title,
                                 artist: track.artist,
                                 artworkURL: track.artworkURL,
                                 playbackStoreID: track.sourceID,
                                 isExplicitItem: track.isExplicit)
            }
            
            if done == 4 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          tracks: searchedTracks)
            }
        }
        
        // MARK: - Spotfy Playlists
        controller.searchSpotify(term, authManager: authManager) { [weak self] snapshots, error in
            done += 1
            
            guard let self = self else { return }
            guard let snapshots = snapshots else {
                print("Error conducting search \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            
            spotifySnapshots = snapshots
            
            if done == 4 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          tracks: searchedTracks)
            }
        }
        
        // MARK: - SYB Playlists
        controller.searchSYB(term) { [weak self] snapshots, error in
            done += 1
            
            guard let self = self else { return }
            guard let snapshots = snapshots else {
                print("Error conducting search \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            
            sybSnapshots = snapshots
            
            if done == 4 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          tracks: searchedTracks)
            }
        }
        
    }
    
    func searchAgain(authManager: AuthorisationManager) {
        runSearch(term: lastSearchTerm, authManager: authManager)
    }
    
    enum PageState: Equatable {
        case loading, success(am: [PlaylistSnapshot],
                              spotify: [PlaylistSnapshot],
                              syb: [PlaylistSnapshot],
                              tracks: [Track]), failed
        
        static func == (lhs: CatalogSearchViewModel.PageState, rhs: CatalogSearchViewModel.PageState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.success(let a, _, _, _), .success(let b, _, _, _)):
                return a == b
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}
