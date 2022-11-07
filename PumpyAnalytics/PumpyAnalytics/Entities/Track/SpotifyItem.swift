//
//  TrackFeatures.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 14/04/2022.
//

import Foundation

public struct SpotifyItem {
    public var isrc: String
    public var id: String
    public var year: Int?
    public var popularity: Int?
    
    public var popularityString: String? {
        if let popularity = popularity {
            return "\(popularity.description)%"
        } else {
            return nil
        }
    }
}
