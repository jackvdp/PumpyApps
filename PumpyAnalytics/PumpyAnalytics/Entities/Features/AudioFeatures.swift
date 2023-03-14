//
//  AudioFeaturesModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 25/02/2022.
//

import Foundation

public struct AudioFeatures {
    public var danceability: Float? //  how dancey a track is based on elements including tempo, rhythm stability, beat strength, and overall regularity
    public var energy: Float? // energetic tracks feel fast, loud, and noisy. For example, death metal has high energy
    public var key: Int?
    public var loudness: Float?
    public var tempo: Float? // BPM
    public var valence: Float? // Happiness
    public var liveliness: Float? // Audience/live music
    public var instrumentalness: Float? // Vocals in a song
    public var speechiness: Float? // Talking e.g. podcast
    public var acousticness: Float?
    public var id: String?
    
    init(danceability: Float,
         energy: Float,
         key: Int?,
         loudness: Float?,
         tempo: Float,
         valence: Float?,
         liveliness: Float?,
         instrumentalness: Float?,
         speechiness: Float?,
         acousticness: Float?,
         id: String?) {
        
        self.danceability = danceability
        self.energy = energy
        self.key = key
        self.loudness = loudness
        self.tempo = tempo
        self.valence = valence
        self.liveliness = liveliness
        self.instrumentalness = instrumentalness
        self.speechiness = speechiness
        self.acousticness = acousticness
        self.id = id
        
    }
    
    public var pumpyScore: Float? {
        if let tempo, let danceability, let energy {
            let bpmScore = (tempo - 50) / 170
            let score = (bpmScore + (energy * 3) + (danceability * 2)) / 6
            return score
        } else {
            return nil
        }
    }
    
    public var danceabilityString: String {
        if let danceability {
            let percentage = danceability * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    public var energyString: String {
        if let energy {
            let percentage = energy * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    public var loudnessString: String {
        if let d = loudness {
            return "\(Int(d))"
        } else {
            return "N/A"
        }
    }
    
    public var tempoString: String {
        if let tempo {
            let int = Int(tempo)
            return "\(int)"
        } else {
            return "N/A"
        }
    }
    
    public var valenceString: String {
        if let d = valence {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    public var livelinessString: String {
        if let d = liveliness {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    public var instrumentalnessString: String {
        if let d = instrumentalness {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    public var speechinessString: String {
        if let d = speechiness {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    public var acousticnessString: String {
        if let d = acousticness {
            let percentage = d * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
    
    public var pumpyScoreString: String {
        
        if let pumpyScore {
            let percentage = pumpyScore * 100
            let int = Int(percentage)
            return "\(int)%"
        } else {
            return "N/A"
        }
    }
}
