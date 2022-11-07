//
//  AMSearch.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/04/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchAM {
    
    func run(_ term: String, next: String? = nil, authManager: AuthorisationManager, completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        AMSearchAPI().run(term, next: next, authManager: authManager) { data, error in
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let data = data else {
                completion(nil, ErrorMessage("Error", "Error decoding playlists from Apple Music server"))
                return
            }
            
            guard let jsonData = try? JSON(data: data) else {
                completion(nil, ErrorMessage("Error", "Error decoding playlists from Apple Music server"))
                return
            }
            
            if let nextUnwrapped = jsonData["results"]["playlists"]["next"].string {
                self.run(term, next: nextUnwrapped, authManager: authManager) { libPlaylists, error in
                    completion(libPlaylists, error)
                }
            }

            if let playlists = jsonData["results"]["playlists"]["data"].array {
                let libraryPlaylists = playlists.compactMap { playlist in
                    LibraryParser().parseForPlaylistFromCatalog(playlist)
                }
                completion(libraryPlaylists, nil)
            } else {
                completion([], nil)
            }

        }
        
    }
}
