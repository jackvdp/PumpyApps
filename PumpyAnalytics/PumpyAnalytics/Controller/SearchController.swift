//
//  SearchController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 26/05/2022.
//

import Foundation

public class SearchController {
    
    public init() {}
    
    let searchAMTracksUseCase = SearchAMTracks()
    
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
        
        SearchSpotify().run(term,
                            authManager: authManager,
                            completion: completion)
    }
    
    public func searchAppleMusic(_ term: String,
                                 getNext: Bool,
                                 authManager: AuthorisationManager,
                                 completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        
        SearchAM().run(term,
                       getNext: getNext,
                       authManager: authManager,
                       completion: completion)
    }
    
    public func searchSYB(_ term: String,
                          completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        
        SearchSYB().run(term,
                        completion: completion)
    }
    
    public func searchArtistStation(_ term: String,
                                    completion: @escaping (PlaylistSnapshot?, ErrorMessage?) -> ()) {
        
        SearchArtistStation().run(term,
                                  completion: completion)
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
    
}
