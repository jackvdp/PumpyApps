//
//  Constants.swift
//  GraphQL Test
//
//  Created by Jack Vanderpump on 10/02/2022.
//

import Foundation

public struct K {
    
    public struct KeychainKeys {
        public static let sybUsernameKey = "userKey"
        public static let sybPasswordKey = "passKey"
        public static let sybTokenKey = "tokenKey"
        
        public static let fireUserKey = "fireUserKey"
        public static let firePassKey = "firePassKey"
        public static let fireTokenKey = "fireTokenKey"
    }
    
    public struct Images {
        public static let pumpyArtwork = "Pumpy Artwork"
    }
    
    public struct Fire {
        public static let playlistLibrary = "playlistLibrary"
        public static let playlists = "playlists"
    }
    
    public struct MusicStore {
        public static let url = "https://api.music.apple.com/v1/"
        public static let musicUserToken = "Music-User-Token"
        public static let authorisation = "Authorization"
        public static let bearerToken = "Bearer \(K.MusicStore.developerToken)"
        public static let artworkKey = 135792468
    }

}
