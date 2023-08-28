//
//  SearchController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 26/05/2022.
//

import Foundation

public class SearchController {
    
    public init() {}
    
    private lazy var searchAMTracksUseCase = SearchAMTracks()
    private lazy var searchSpotifyUseCase = SearchSpotify()
    private lazy var searchAMPlaylistsUseCase = SearchAM()
    private lazy var searchSYBUseCase = SearchSYB()
    private lazy var searchArtistStationUseCase = SearchArtistStation()
    
    public func searchAll(_ term: String,
                          authManager: AuthorisationManager,
                          completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        
        searchSpotify(term, authManager: authManager, completion: completion)
        searchAppleMusic(term, getNext: true, authManager: authManager, completion: completion)
        searchSYB(term, completion: completion)
    
    }
    
    public func searchSpotify(_ term: String,
                              authManager: AuthorisationManager,
                              completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        
        searchSpotifyUseCase.run(term,
                                 authManager: authManager,
                                 completion: completion)
    }
    
    public func searchAppleMusic(_ term: String,
                                 getNext: Bool,
                                 authManager: AuthorisationManager,
                                 completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {

        searchAMPlaylistsUseCase.run(
            term,
            getNext: getNext,
            authManager: authManager,
            completion: completion
        )
    }
    
    public func searchSYB(_ term: String,
                          completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        
        searchSYBUseCase.run(term, completion: completion)
    }
    
    public func searchArtistStation(_ term: String,
                                    completion: @escaping (PlaylistSnapshot?, ErrorMessage?) -> ()) {
        
        searchArtistStationUseCase.run(term, completion: completion)
    }
    
    public func searchAMTracks(_ term: String,
                               limit: Int = 25,
                               authManager: AuthorisationManager,
                               completion: @escaping ([Track], ErrorMessage?) -> ()) {
        
        searchAMTracksUseCase.execute(term: term,
                                      limit: limit,
                                      authManager: authManager,
                                      completion: completion)
    }
    
    // MARK: Search Suggestions
    
    private let suggestionsUseCase = GetSearchSuggestions()
    
    public func searchSuggestions(term: String,
                                  authManager: AuthorisationManager,
                                  completion: @escaping ([String], ErrorMessage?) -> ()) {
        suggestionsUseCase.execute(term: term,
                                   authManager: authManager,
                                   completion: completion)
    }
    
}
