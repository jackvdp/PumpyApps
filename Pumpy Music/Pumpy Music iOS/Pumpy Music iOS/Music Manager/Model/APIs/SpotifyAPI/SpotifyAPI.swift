//
//  SpotifyAPI.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/09/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

//import Foundation
//import PumpyLibrary
//
//class SpotifyAPI {
//    
//    let storefrontID: String
//    let spotifyToken: String
//    
//    init(spotifyToken: String, storefrontID: String = "gb") {
//        self.storefrontID = storefrontID
//        self.spotifyToken = spotifyToken
//    }
//    
//    func getAudioFeaturesofTrack(id: String, completion: @escaping (AudioFeatures) -> ()) {
//        getISRCFromTrack(id: id) { isrc in
//            self.getSpotifyTrackFromISRC(isrc: isrc) { spotID in
//                self.getTrackFeaturesFromSpotifyID(id: spotID) { features in
//                    print(features)
//                    completion(features)
//                }
//            }
//        }
//    }
//    
//    private func getISRCFromTrack(id: String, completion: @escaping (String) -> ()){
//        if let musicURL = URL(string: "\(K.MusicStore.url)catalog/\(storefrontID)/songs/\(id)") {
//            var musicRequest = URLRequest(url: musicURL)
//            musicRequest.httpMethod = "GET"
//            musicRequest.addValue(K.MusicStore.bearerToken, forHTTPHeaderField: K.MusicStore.authorisation)
//            
//            URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
//                guard error == nil else { return }
//                if let d = data {
//                    if let isrc = self.parseForIRSC(data: d) {
//                        completion(isrc)
//                    }
//                }
//            }.resume()
//        }
//    }
//    
//    private func parseForIRSC(data: Data) -> String? {
//        if let jsonData = try? JSON(data: data) {
//            if let collections = jsonData["data"].array {
//                for collection in collections {
//                    if let isrc = collection["attributes"]["isrc"].string {
//                        return isrc
//                    }
//                }
//            }
//        }
//        return nil
//    }
//    
//    private func getSpotifyTrackFromISRC(isrc: String, completion: @escaping (String) -> ()) {
//        if let musicURL = URL(string: "https://api.spotify.com/v1/search?type=track&q=isrc:\(isrc)") {
//            var musicRequest = URLRequest(url: musicURL)
//            musicRequest.httpMethod = "GET"
//            musicRequest.addValue("Bearer \(spotifyToken)", forHTTPHeaderField: "Authorization")
//            
//            URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
//                guard error == nil else { return }
//                if let d = data {
//                    if let id = self.parseForSpotifyID(data: d) {
//                        completion(id)
//                    }
//                }
//            }.resume()
//        }
//    }
//    
//    private func parseForSpotifyID(data: Data) -> String? {
//        if let jsonData = try? JSON(data: data) {
//            if let tracks = jsonData["tracks"].dictionary {
//                if let items = tracks["items"]?.array {
//                    for item in items {
//                        if let id = item["id"].string {
//                            return id
//                        }
//                    }
//                }
//            }
//        }
//        return nil
//    }
//    
//    private func getTrackFeaturesFromSpotifyID(id: String, completion: @escaping (AudioFeatures) -> ()) {
//        if let musicURL = URL(string: "https://api.spotify.com/v1/audio-features/\(id)") {
//            var musicRequest = URLRequest(url: musicURL)
//            musicRequest.httpMethod = "GET"
//            musicRequest.addValue("Bearer \(spotifyToken)", forHTTPHeaderField: "Authorization")
//            
//            URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
//                guard error == nil else { return }
//                if let d = data {
//                    if let features = self.parseForTrackFeatures(data: d) {
//                        completion(features)
//                    }
//                }
//            }.resume()
//        }
//    }
//    
//    private func parseForTrackFeatures(data: Data) -> AudioFeatures? {
//        if let jsonData = try? JSON(data: data) {
//            return AudioFeatures(danceability: jsonData["danceability"].float,
//                                         energy: jsonData["energy"].float,
//                                         key: jsonData["key"].int,
//                                         loudness: jsonData["loudness"].float,
//                                         tempo: jsonData["tempo"].float,
//                                         valence: jsonData["valence"].float,
//                                         liveliness: jsonData["liveness"].float)
//        }
//        return nil
//    }
//    
//}
