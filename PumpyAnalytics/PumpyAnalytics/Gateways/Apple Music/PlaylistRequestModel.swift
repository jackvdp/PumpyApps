//
//  PlaylistRequestModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 24/03/2022.
//

import Foundation
import Alamofire

struct PlaylistRequest {
    
    var name: String
    var trackIDs: [String]
    
    var dictionary: Parameters {
        [
            "attributes" : [
                "name": name
            ],
            "relationships" : [
                "tracks": [
                    "data": addTracks()
                ]
            ]
        ]
    }
    
    func addTracks() -> [[String:String]] {
        return trackIDs.map {
            [
                "id" : $0,
                "type" : "songs"
            ]
        }
    }
    
}

