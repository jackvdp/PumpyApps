//
//  AppleMusicAPI.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 24/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import StoreKit
import MediaPlayer
import PumpyLibrary

class AppleMusicAPI {
    
    var userToken: String
    var storefrontID: String
    
    init(token: String, storeFront: String) {
        userToken = token
        storefrontID = storeFront
    }
    
    // MARK: - Playlist
    
    func getPlaylistURL(playlist: String, completionHandler: @escaping (String) -> Void) {
        let query = MPMediaQuery.playlists()
        let predicate = MPMediaPropertyPredicate(value: playlist,
                                                 forProperty: MPMediaPlaylistPropertyName,
                                                 comparisonType: .equalTo)
        query.addFilterPredicate(predicate)
        if let plist = query.collections?.first as? MPMediaPlaylist {
            if let id = plist.cloudGlobalID {
                if let musicURL = URL(string: "\(K.MusicStore.url)catalog/\(storefrontID)/playlists/\(id)") {
                    var musicRequest = URLRequest(url: musicURL)
                    musicRequest.httpMethod = "GET"
                    musicRequest.addValue(K.MusicStore.bearerToken, forHTTPHeaderField: K.MusicStore.authorisation)
                    
                    URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                        guard error == nil else { return }
                        if let d = data {
                            if let urlString = self.parsePlaylisrForURL(data: d) {
                                completionHandler(urlString)
                            }
                        }
                    }.resume()
                }
            }
            
            
        }
    }
    
    func parsePlaylisrForURL(data: Data) -> String? {
        let decoder = JSONDecoder()
        if let playlistStruct = try? decoder.decode(PlaylistURL.self, from: data) {
            return playlistStruct.data.first?.attributes.url
        }
        return nil
    }
    
    private struct PlaylistURL: Codable {
        var data: [PlaylistURLData]
    }
    
    private struct PlaylistURLData: Codable {
        var attributes: PlaylistURLAttributes
    }
    
    private struct PlaylistURLAttributes: Codable {
        var url: String
    }
}
