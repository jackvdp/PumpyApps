//
//  BrowseController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 02/09/2022.
//

import Foundation

public class BrowseController {
    
    public init() {}
    let getSuggestionsUseCase = GetSuggestions()
    
    deinit {
        print("Bye bye 3")
    }
    
    public func getAppleMusicSuggestions(authManager: AuthorisationManager,
                                         completion: @escaping ([SuggestedCollection], ErrorMessage?)->()) {
        getSuggestionsUseCase.execute(authManager: authManager, completion: completion)
    }
    
}
