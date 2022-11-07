//
//  LibraryPlaylistsController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 08/06/2022.
//

import Foundation
import Alamofire

public class LibraryPlaylistsController {
    
    public init() {}
    
    public func getAppleMusicLibraryPlaylists(authManager: AuthorisationManager, completion: @escaping ([PlaylistSnapshot], AFError?) -> ()) {
        
        GetAMLibPlaylists().execute(authManager: authManager, completion: completion)
        
    }
    
    
}
