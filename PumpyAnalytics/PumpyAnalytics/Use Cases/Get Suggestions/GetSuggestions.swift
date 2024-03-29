//
//  GetRecommendations.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 02/09/2022.
//

import Foundation

class GetSuggestions {
    
    let gateway = SuggestionsGateway()

    func execute(authManager: AuthorisationManager, completion: @escaping ([SuggestedCollection], ErrorMessage?)->()) {
        
        gateway.get(authManager: authManager) { [weak self] suggestions, code in
            guard let self else { return }
            let (collection, error) = self.handleResponse(suggestions: suggestions, code: code)
            completion(collection, error)
        }
        
    }
    
    func handleResponse(suggestions: Suggestions?, code: Int) -> ([SuggestedCollection], ErrorMessage?) {
        guard let suggestions = suggestions, code == 200 else {
            return ([], self.handleError(code: code))
        }
        
        var collections: [SuggestedCollection] = suggestions.data.compactMap { suggestion in

            let items = getItems(suggestion: suggestion)
            
            return SuggestedCollection(title: suggestion.attributes.title.stringForDisplay,
                                       items: items,
                                       types: suggestion.attributes.resourceTypes.compactMap { $0.publicType })
        }
        
        // Place stations at the top of the list
        if let stations = collections.first(where: { $0.title.contains("Station") }) {
            collections.removeAll(where: { $0 == stations })
            collections.insert(stations, at: 0)
        }
        
        return (collections, nil)
    }
    
    func handleError(code: Int) -> ErrorMessage {
        print("Error getting suggestions \(code)")
        return ErrorMessage("Error Getting Suggestions", "Please Try Again")
    }
    
    private func getItems(suggestion: Suggestions.SuggestionBoundaryDatum) -> [SuggestedItem] {
        let items: [SuggestedItem] = suggestion.relationships.contents.data.compactMap { item in
            if let type = item.type.publicType {
                return SuggestedItem(name: item.attributes.name,
                                     id: item.id,
                                     type: type,
                                     artworkURL: item.attributes.artwork.url,
                                     curator: item.attributes.curatorName ?? item.attributes.artistName ?? "")
            }
            return nil
        }
        return items
    }
    
}
