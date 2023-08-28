//
//  CatalogSearchViewModel.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 14/09/2022.
//

import Foundation
import PumpyAnalytics
import PumpyShared
import UIKit

class SearchViewModel: ObservableObject {
    
    @Published var pageState = PageState.searchStage
    @Published var searchText = String()
    @Published var searchSuggestions = [String]()
    @Published var recentSearches = [String]()
    @Published var searchTextChangedByCompletion = false
    private let recentSearchesKey = "recentSearches"
    private let controller = SearchController()
    private let debouncer = Debouncer()
    
    init() {
        getRecentSearches()
    }
    
    func getSuggestions(authManager: AuthorisationManager) {
        if searchText.count > 2 {
            debouncer.handle { [weak self] in
                guard let self, self.pageState == .searchStage else { return }
                self.controller.searchSuggestions(term: self.searchText,
                                             authManager: authManager) { [weak self] suggestions, error in
                    guard self?.pageState == .searchStage else { return }
                    self?.searchSuggestions = suggestions
                }
            }
        } else {
            searchSuggestions = []
        }
    }
    
    func searchWithSuggestion(_ completionTerm: String, authManager: AuthorisationManager) {
        searchTextChangedByCompletion = true
        searchText = completionTerm
        runSearch(authManager: authManager)
    }
    
    func runSearch(authManager: AuthorisationManager) {
        UIApplication.shared.endEditing()
        pageState = .loading
        setRecentSearches()
        var amSnapshots = [PlaylistSnapshot]()
        var spotifySnapshots = [PlaylistSnapshot]()
        var sybSnapshots = [PlaylistSnapshot]()
        var artistStations = [PlaylistSnapshot]()
        var searchedTracks = [PumpyAnalytics.Track]()
        var done = 0
        
        // MARK: - AM Playlists
        controller.searchAppleMusic(searchText,
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
            
            if done == 5 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          artistStations: artistStations,
                                          tracks: searchedTracks)
            }
        }
        
        // MARK: - AM Tracks
        controller.searchAMTracks(searchText, authManager: authManager) { [weak self] tracks, error in
            done += 1
            
            guard let self = self else { return }
            if let e = error {
                print("Error conducting search \(e.message)")
                self.pageState = .failed
                return
            }
            searchedTracks = tracks
            
            if done == 5 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          artistStations: artistStations,
                                          tracks: searchedTracks)
            }
        }
        
        // MARK: - Spotfy Playlists
        controller.searchSpotify(searchText, authManager: authManager) { [weak self] snapshots, error in
            done += 1
            
            guard let self = self else { return }
            guard let snapshots = snapshots else {
                print("Error conducting search \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            
            spotifySnapshots = snapshots
            
            if done == 5 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          artistStations: artistStations,
                                          tracks: searchedTracks)
            }
        }
        
        // MARK: - SYB Playlists
        controller.searchSYB(searchText) { [weak self] snapshots, error in
            done += 1
            
            guard let self = self else { return }
            guard let snapshots = snapshots else {
                print("Error conducting search \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            
            sybSnapshots = snapshots
            
            if done == 5 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          artistStations: artistStations,
                                          tracks: searchedTracks)
            }
        }
        
        // MARK: - Artist Station
        controller.searchArtistStation(searchText) { [weak self] snapshots, error in
            done += 1
            
            guard let self = self else { return }
            guard let snapshots = snapshots else {
                print("Error conducting search \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            
            artistStations = [snapshots]
            
            if done == 5 {
                self.pageState = .success(am: amSnapshots,
                                          spotify: spotifySnapshots,
                                          syb: sybSnapshots,
                                          artistStations: artistStations,
                                          tracks: searchedTracks)
            }
        }
        
    }
    
    // MARK: - Recent Searches
    
    private func getRecentSearches() {
        if let searches = UserDefaults.standard.array(forKey: recentSearchesKey) as? [String] {
            recentSearches = searches
        }
    }
    
    private func setRecentSearches() {
        recentSearches.insert(searchText, at: 0)
        recentSearches.removeDuplicates()
        if recentSearches.count > 5 {
            recentSearches.removeLast()
        }
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
    }
    
    // MARK: - Page State
    
    enum PageState: Equatable {
        case searchStage
        case loading
        case success(am: [PlaylistSnapshot],
                     spotify: [PlaylistSnapshot],
                     syb: [PlaylistSnapshot],
                     artistStations: [PlaylistSnapshot],
                     tracks: [Track])
        case failed
        
        static func == (lhs: SearchViewModel.PageState, rhs: SearchViewModel.PageState) -> Bool {
            switch (lhs, rhs) {
            case (.searchStage, .searchStage):
                return true
            case (.loading, .loading):
                return true
            case (.success(let a, _, _, _, _), .success(let b, _, _, _, _)):
                return a == b
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}

private extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
