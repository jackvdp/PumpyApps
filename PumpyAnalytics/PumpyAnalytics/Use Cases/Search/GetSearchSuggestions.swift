//
//  GetSearchSuggestions.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 20/04/2023.
//

import Foundation
import MusicKit

class GetSearchSuggestions {
    
    private let gateway = SearchSuggestionsGateway()
    
    func execute(term: String,
                 authManager: AuthorisationManager,
                 completion: @escaping ([String], ErrorMessage?) -> ()) {
        
        gateway.get(term: term, authManager: authManager) { suggestions, statusCode in
            
            guard let suggestions else {
                completion([], ErrorMessage("No data", "No search suggestions. Code: \(statusCode)"))
                return
            }
            
            let terms = suggestions.results.suggestions.map { $0.searchTerm }
            
            completion(terms, nil)
        }
    }
    
}
