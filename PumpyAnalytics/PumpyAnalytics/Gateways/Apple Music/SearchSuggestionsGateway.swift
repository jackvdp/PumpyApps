//
//  SearchSuggestionsGateway.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 22/04/2023.
//

import Foundation
import Alamofire

class SearchSuggestionsGateway {
    
    func get(term: String, authManager: AuthorisationManager, completion: @escaping (SearchSuggestions?, Int)->()) {
        
        guard let safeTerm = term.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            print("Unsafe term")
            completion(nil, 499)
            return
        }
        
        let url = "https://api.music.apple.com/v1/catalog/\(authManager.storefront ?? "gb")/search/suggestions?term=\(safeTerm)&kinds=terms"

        
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken)
        ])
        
        AF.request(url, headers: headers).responseDecodable(of: SearchSuggestions.self) { response in
            print(response.error?.errorDescription ?? "")
            completion(response.value, response.response?.statusCode ?? 400)
        }
        
    }
    
}
