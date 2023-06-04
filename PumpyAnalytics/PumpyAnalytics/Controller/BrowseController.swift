//
//  BrowseController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 02/09/2022.
//

import Foundation

public class BrowseController {
    
    public init() {}
    
    public func getAppleMusicSuggestions(authManager: AuthorisationManager,
                                         completion: @escaping ([SuggestedCollection], ErrorMessage?)->()) {
        GetSuggestions().execute(authManager: authManager, completion: completion)
    }
    
}
