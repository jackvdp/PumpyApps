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
        var playlistSnapshots = [PlaylistSnapshot]()
        var constructedTracks = [ConstructedTrack]()
        var done = 0
        
        controller.searchAppleMusic(term, authManager: authManager) { [weak self] snapshots, error in
            done += 1
            
            guard let self = self else { return }
            guard let snapshots = snapshots else {
                print("Error conducting search \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            playlistSnapshots = snapshots
            
            if done == 2 {
                self.pageState = .success(playlistSnapshots, constructedTracks)
            }
        }
        
        controller.searchAMTracks(term, authManager: authManager) { [weak self] tracks, error in
            done += 1
            
            guard let self = self else { return }
            if let e = error {
                print("Error conducting search \(e.message)")
                self.pageState = .failed
                return
            }
            constructedTracks = tracks.compactMap { track in
                ConstructedTrack(title: track.title,
                                 artist: track.artist,
                                 artworkURL: track.artworkURL,
                                 playbackStoreID: track.sourceID,
                                 isExplicitItem: track.isExplicit)
            }
            
            if done == 2 {
                self.pageState = .success(playlistSnapshots, constructedTracks)
            }
        }
    }
    
    func searchAgain(authManager: AuthorisationManager) {
        runSearch(term: lastSearchTerm, authManager: authManager)
    }
    
    enum PageState: Equatable {
        case loading, success([PlaylistSnapshot], [Track]), failed
        
        static func == (lhs: CatalogSearchViewModel.PageState, rhs: CatalogSearchViewModel.PageState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.success(let a, _), .success(let b, _)):
                return a == b
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}
