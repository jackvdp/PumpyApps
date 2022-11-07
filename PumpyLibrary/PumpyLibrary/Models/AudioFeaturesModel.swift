//
//  AudioFeaturesModel.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 27/10/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation

public struct AudioFeatures: Codable, Hashable {
    public init(danceability: Float? = nil, energy: Float? = nil, key: Int? = nil, loudness: Float? = nil, tempo: Float? = nil, valence: Float? = nil, liveliness: Float? = nil) {
        self.danceability = danceability
        self.energy = energy
        self.key = key
        self.loudness = loudness
        self.tempo = tempo
        self.valence = valence
        self.liveliness = liveliness
    }
    
    var danceability: Float?
    var energy: Float?
    var key: Int?
    var loudness: Float?
    var tempo: Float?
    var valence: Float?
    var liveliness: Float?
}

struct AudioFeaturesString {
    
    let features: AudioFeatures
    
    var danceabilityString: String {
        if let d = features.danceability {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    var energyString: String {
        if let d = features.energy {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    var loudnessString: String {
        if let d = features.loudness {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    var tempoString: String {
        if let d = features.tempo {
            let int = Int(d)
            return "\(int)"
        } else {
            return "N/A"
        }
    }
    
    var valenceString: String {
        if let d = features.valence {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    var livelinessString: String {
        if let d = features.liveliness {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
}
