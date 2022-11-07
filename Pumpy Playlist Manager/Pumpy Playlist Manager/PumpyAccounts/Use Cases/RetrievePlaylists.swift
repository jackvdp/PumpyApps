//
//  RetrievePlaylists.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/06/2022.
//

import Foundation
import Firebase
import PumpyAnalytics

class RetrievePlaylists {
    
    func execute(username: String, completion: @escaping ([PlaylistSnapshot])->()) -> ListenerRegistration {
        PlaylistDBGateway(username: username).downloadPlaylists(completion: completion)
    }
    
}
