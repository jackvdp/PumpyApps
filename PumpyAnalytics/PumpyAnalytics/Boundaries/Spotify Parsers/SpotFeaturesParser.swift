//
//  SpotifyAPIParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/03/2022.
//

import Foundation
import SwiftyJSON

class SpotifyFeaturesParser {
    
    func transformJSONtoAudioFeature(_ jsonData: JSON) -> AudioFeatures? {
        if let energy = jsonData["energy"].float,
           let tempo =  jsonData["tempo"].float,
           let danceable = jsonData["danceability"].float {
            return AudioFeatures(danceability: danceable,
                                 energy: energy,
                                 key: jsonData["key"].int,
                                 loudness: jsonData["loudness"].float,
                                 tempo: tempo,
                                 valence: jsonData["valence"].float,
                                 liveliness: jsonData["liveness"].float,
                                 instrumentalness: jsonData["instrumentalness"].float,
                                 speechiness: jsonData["speechiness"].float,
                                 acousticness: jsonData["acousticness"].float,
                                 id: jsonData["id"].string)
        } else {
            return nil
        }
    }
    
    func parseForTrackFeatures(data: Data) -> AudioFeatures? {
        if let jsonData = try? JSON(data: data) {
            return transformJSONtoAudioFeature(jsonData)
        }
        return nil
    }
    
    func parseForManyTrackFeatures(data: Data) -> [AudioFeatures] {
        if let jsonData = try? JSON(data: data) {
            if let afArray = jsonData["audio_features"].array {
                return afArray.compactMap { item in
                    transformJSONtoAudioFeature(item)
                }
            }
        }
        return []
    }
    
    
}
