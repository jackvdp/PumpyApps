//
//  GetAMLibPlaylists.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 08/06/2022.
//

import Foundation
import Alamofire

class GetAMLibPlaylists {
    
    func execute(authManager: AuthorisationManager, completion: @escaping ([PlaylistSnapshot], AFError?) -> ()) {
        AMLibraryAPI().getPlaylists(authManager: authManager, completion: completion)
    }
    
}
