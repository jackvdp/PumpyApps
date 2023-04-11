//
//  GetGenres.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 11/04/2023.
//

import Foundation

class GetGenres {
    
    private let gateway = SpotifyGenresGateway()
    
    func execute(authManager: AuthorisationManager, completion: @escaping (_ genres: [String]) -> ()) {
        gateway.run(authManager: authManager) { genres, error in
            guard error == nil else {
                print("Failed to get genres")
                return
            }
            
            let cpaitalisedGenres = genres.map { $0.capitalized }
            
            completion(cpaitalisedGenres)
        }
    }
}
