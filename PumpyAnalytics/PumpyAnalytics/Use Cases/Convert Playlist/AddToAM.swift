//
//  AddToAM.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 10/08/2023.
//

import Foundation

class AddToAppleMusicLibrary {
    
    private let gateway = AddToAppleMusicGateway()
    
    func execute(playlistID: String,
                 authManager: AuthorisationManager,
                 completion: @escaping (ErrorMessage?) -> ()) {
        
        gateway.add(playlistID: playlistID, authManager: authManager) { code in
            
            switch code {
            case 201, 202:
                print("Playlist added successfully.")
                completion(nil)
            case 401, 403:
                print("Playlist added failed: Unauthorised.")
                completion(
                    ErrorMessage("Failed to add Playlist to library", "Unauthorised")
                )
            case 500:
                print("Playlist conversion failed: Internal Server Error.")
                completion(
                    ErrorMessage("Internal server error thrown. Plylist was likely added though",
                                 "Potential Error")
                )
            default:
                print("Playlist conversion failed: Unknown.")
                completion(
                    ErrorMessage("Failed to Convert Playlist to Apple Music", "Unknown")
                )
            }
            
        }
        
    }
    
}
