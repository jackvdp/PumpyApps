//
//  CreateAMPlaylist.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 24/05/2022.
//

import Foundation
import AVFoundation

class ConvertPlaylistToAppleMusic {
    
    func execute(playlistName: String,
                tracks: [Track],
                authManager: AuthorisationManager,
                completion: @escaping (ErrorMessage?) -> ()) {
        
        AMCreatePlaylistAPI().createPlaylist(name: playlistName,
                                             tracks: tracks,
                                             authManager: authManager) { code in
            
            switch code {
            case 201:
                print("Playlist converted successfully.")
                completion(nil)
            case 401, 403:
                print("Playlist conversion failed: Unauthorised.")
                completion(
                    ErrorMessage("Failed to Convert Playlist to Apple Music", "Unauthorised")
                )
            case 500:
                print("Playlist conversion failed: Internal Server Error.")
                completion(
                    ErrorMessage("Internal server error thrown. Plylist was likely created though",
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
