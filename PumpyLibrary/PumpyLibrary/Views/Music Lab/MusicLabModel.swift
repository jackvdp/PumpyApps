//
//  MusicLabModel.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 11/03/2023.
//

import Foundation
import PumpyAnalytics

struct MusicLabModel {
    
    func transform(tracks: [PumpyAnalytics.Track], playlistSize: Int, seedAttributes: [SeedAttributes]) -> PlaylistSeeding {
        let spotIDs = tracks.compactMap { $0.spotifyItem?.id }
        
        let popularity = seedAttributes.first(where:  { $0.keyPath == nil})
        let energy = seedAttributes.first(where: { $0.keyPath == \.energy})
        let vocals = seedAttributes.first(where: { $0.keyPath == \.instrumentalness})
        let tempo = seedAttributes.first(where: { $0.keyPath == \.tempo})
        let danceable = seedAttributes.first(where: { $0.keyPath == \.danceability})
        let mood = seedAttributes.first(where: { $0.keyPath == \.valence})
        let acoustics = seedAttributes.first(where: { $0.keyPath == \.acousticness})
        
        // Lower values
        let popularityLowerValue = popularity?.transformToSeeding(forMax: false)
        let energyLowerValue = energy?.transformToSeeding(forMax: false)
        let vocalsLowerValue = vocals?.transformToSeeding(forMax: false)
        let tempoLowerValue = tempo?.transformToSeeding(forMax: false)
        let danceableLowerValue = danceable?.transformToSeeding(forMax: false)
        let moodLowerValue = mood?.transformToSeeding(forMax: false)
        let acousticsLowerValue = acoustics?.transformToSeeding(forMax: false)
        
        // Upper values
        let popularityHigherValue = popularity?.transformToSeeding(forMax: true)
        let energyHigherValue = energy?.transformToSeeding(forMax: true)
        let vocalsHigherValue = vocals?.transformToSeeding(forMax: true)
        let tempoHigherValue = tempo?.transformToSeeding(forMax: true)
        let danceableHigherValue = danceable?.transformToSeeding(forMax: true)
        let moodHigherValue = mood?.transformToSeeding(forMax: true)
        let acousticsHigherValue = acoustics?.transformToSeeding(forMax: true)
        
        // Create seeding active ? value : nil
        return PlaylistSeeding(trackIDs: spotIDs, artistIDs: [], genres: [], playlistSize: playlistSize,
                               seeding: AttributeSeeding(maxDanceability: danceableHigherValue,
                                                         minDanceability: danceableLowerValue,
                                                         maxEnergy: energyHigherValue,
                                                         minEnergy: energyLowerValue,
                                                         maxPopularity: popularityHigherValue == nil ? nil : Int(popularityHigherValue!),
                                                         minPopularity: popularityLowerValue == nil ? nil : Int(popularityLowerValue!),
                                                         maxBPM: tempoHigherValue == nil ? nil : Int(tempoHigherValue!),
                                                         minBPM: tempoLowerValue == nil ? nil : Int(tempoLowerValue!),
                                                         maxHappiness: moodHigherValue,
                                                         minHappiness: moodLowerValue,
                                                         maxLoudness: nil,
                                                         minLoudness: nil,
                                                         maxSpeechiness: vocalsHigherValue,
                                                         minSpeechiness: vocalsLowerValue,
                                                         maxAcoustic: acousticsHigherValue,
                                                         minAcoustic: acousticsLowerValue))
    }
    
}

extension SeedAttributes {
    func transformToSeeding(forMax: Bool) -> Double? {
        guard let averageValue, self.active else { return nil }
        
        let value = forMax ? Float(self.higherValue) : Float(0 - self.lowerValue)
        
        switch self.keyPath {
        case .some(\.tempo):
            return Double(averageValue + value)
        case .none:
            // For popularity
            return max(0, min(100, Double(averageValue + value)))
        default:
            return max(0, min(1, Double(averageValue + (value / 100))))
        }
    }
}
