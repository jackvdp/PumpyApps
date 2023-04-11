//
//  MusicLabModel.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 11/03/2023.
//

import Foundation
import PumpyAnalytics

class SeedAttributes: ObservableObject {
    init(name: String, lowerLabel: String, higherLabel: String,
         keyPath: KeyPath<PumpyAnalytics.AudioFeatures, Float?>?,
         descriptionKeyPath: KeyPath<PumpyAnalytics.AudioFeatures, String>?) {
        self.name = name
        self.lowerLabel = lowerLabel
        self.higherLabel = higherLabel
        self.keyPath = keyPath
        self.descriptionKeyPath = descriptionKeyPath
    }
    
    var name: String
    var lowerLabel: String
    var higherLabel: String
    @Published var lowerValue: Double = 0.0
    @Published var higherValue: Double = 1.0
    @Published var active: Bool = true
    var keyPath: KeyPath<PumpyAnalytics.AudioFeatures, Float?>?
    var descriptionKeyPath: KeyPath<PumpyAnalytics.AudioFeatures, String>?
    
    var averageValue: Float?
    
    func setAverage(tracks: [PumpyAnalytics.Track]) {
        let attributeValues: [Float] = {
            if let keyPath {
                return tracks.compactMap {
                    guard let features = $0.audioFeatures else { return nil }
                    return features[keyPath: keyPath]
                }
            } else {
                return tracks.compactMap {
                    guard let popularity = $0.spotifyItem?.popularity else { return nil }
                    return Float(popularity)
                }
            }
        }()
        
        averageValue = attributeValues.reduce(0, +) / Float(attributeValues.count)
        let (lower, higher) = getLowerAndUpperValueBasedOnAverage()
        lowerValue = lower
        higherValue = higher
    }
}

extension SeedAttributes {
    
    var actualHigher: Double? {
        transformSliderValueToActual(higherValue)
    }
    
    var actualHigherDescription: String {
        transformSliderValueToString(higherValue)
    }
    
    var actualLower: Double? {
        transformSliderValueToActual(lowerValue)
    }
    
    var actualLowerDescription: String {
        transformSliderValueToString(lowerValue)
    }
    
    /// Transfoms slider value to an actual value. E.g. 0.25 to a BPM of 90
    /// - Parameter forMax: `true` refrs to the higher value
    /// - Returns: The actual value e.g. BPM of 90
    func transformSliderValueToActual(_ value: Double) -> Double? {
        guard active else { return nil }
        
        switch self.keyPath {
        case .some(\.tempo):
            let minValue = 60.0
            let maxValue = 180.0
            return round(minValue + (value * (maxValue - minValue)))
        case .none:
            // For popularity
            return round(max(0, min(1, Double(value))) * 100)
        default:
            return (round(max(0, min(1, Double(value))) * 100) / 100)
        }
    }
    
    /// Transfoms a string representation of `transformSliderValueToActual` adding % or BPM when appropriate
    /// - Parameter forMax: if this is for the to the higher or lower value
    /// - Returns: A string representation of the value 90 BPM or 10%
    func transformSliderValueToString(_ value: Double) -> String {
        guard let number = transformSliderValueToActual(value) else { return "–" }
        
        switch self.keyPath {
        case .some(\.tempo):
            return Int(number).description + " BPM"
        case .none:
            // For popularity
            return Int(number).description + "%"
        default:
            return Int(number * 100).description + "%"
        }
    }
    
    func getLowerAndUpperValueBasedOnAverage() -> (Double, Double) {
        guard let averageValue else { return (0.25, 0.75) }
        let averageDouble = Double(averageValue)
        let factor = 0.25
        
        switch keyPath {
        case .some(\.tempo):
            let minValue = 60.0
            let maxValue = 180.0
            
            let scaledValue = (averageDouble - minValue) / (maxValue - minValue)
            let clampedValue = max(0, min(1, scaledValue))
            
            let less = max(0, clampedValue - factor)
            let more = min(1, clampedValue + factor)
            
            return (less, more)
        case .none:
            // For popularity
            let lowerBound = 0.0
            let upperBound = 1.0
            let value = averageDouble / 100
            let less = max(lowerBound, value - factor)
            let more = min(upperBound, value + factor)
            return (less, more)
        default:
            let lowerBound = 0.0
            let upperBound = 1.0
            let value = averageDouble
            let less = max(lowerBound, value - factor)
            let more = min(upperBound, value + factor)
            return (less, more)
        }
    }
}

extension Array where Element == SeedAttributes {
    /// Transform the array of model useds to determine the bounds fo the various attributes and convert it itno a model accepted by the Analytics framework and ready to create send to endpoint
    /// - Parameters:
    ///   - tracks: The seed tracks used as part of the recommendations request.
    ///   - playlistSize: The size of the playlist. Defaults to 50
    /// - Returns: The `PlaylistSeeding` which can be given to the Analytics framework as part of the recommendations request
    func transformToAnalyticsSeeding(tracks: [PumpyAnalytics.Track], genres: [String], playlistSize: Int = 50) -> PlaylistSeeding {
        let spotIDs = tracks.compactMap { $0.spotifyItem?.id }
        
        let popularity = self.first(where:  { $0.keyPath == nil})
        let energy = self.first(where: { $0.keyPath == \.energy})
        let vocals = self.first(where: { $0.keyPath == \.instrumentalness})
        let tempo = self.first(where: { $0.keyPath == \.tempo})
        let danceable = self.first(where: { $0.keyPath == \.danceability})
        let mood = self.first(where: { $0.keyPath == \.valence})
        let acoustics = self.first(where: { $0.keyPath == \.acousticness})
        
        // Lower values
        let popularityLowerValue = popularity?.actualLower
        let energyLowerValue = energy?.actualLower
        let vocalsLowerValue = vocals?.actualLower
        let tempoLowerValue = tempo?.actualLower
        let danceableLowerValue = danceable?.actualLower
        let moodLowerValue = mood?.actualLower
        let acousticsLowerValue = acoustics?.actualLower
        
        // Upper values
        let popularityHigherValue = popularity?.actualHigher
        let energyHigherValue = energy?.actualHigher
        let vocalsHigherValue = vocals?.actualHigher
        let tempoHigherValue = tempo?.actualHigher
        let danceableHigherValue = danceable?.actualHigher
        let moodHigherValue = mood?.actualHigher
        let acousticsHigherValue = acoustics?.actualHigher
        
        // Create seeding active ? value : nil
        return PlaylistSeeding(trackIDs: spotIDs,
                               artistIDs: [],
                               genres: genres,
                               playlistSize: playlistSize,
                               seeding: AttributeSeeding(
                                maxDanceability: danceableHigherValue,
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
                                maxInstrumnetalness: vocalsHigherValue,
                                minInstrumnetalness: vocalsLowerValue,
                                maxAcoustic: acousticsHigherValue,
                                minAcoustic: acousticsLowerValue
                               ))
    }
}

extension SeedAttributes {
    static func defaultAttributes() -> [SeedAttributes] {
        return [
            .init(name: "Popularity", lowerLabel: "Playing at bars", higherLabel: "World Tour",
                  keyPath: nil, descriptionKeyPath: nil),
            .init(name: "Energy", lowerLabel: "Chill", higherLabel: "Buzzing",
                  keyPath: \.energy, descriptionKeyPath: \.energyString),
            .init(name: "Instrumental", lowerLabel: "Anthem", higherLabel: "No Words",
                  keyPath: \.instrumentalness, descriptionKeyPath: \.instrumentalnessString),
            .init(name: "BPM", lowerLabel: "Slow", higherLabel: "Fast",
                  keyPath: \.tempo, descriptionKeyPath: \.tempoString),
            .init(name: "Danceable", lowerLabel: "Sitting down", higherLabel: "Disco",
                  keyPath: \.danceability, descriptionKeyPath: \.danceabilityString),
            .init(name: "Mood", lowerLabel: "Downer", higherLabel: "Upper",
                  keyPath: \.valence, descriptionKeyPath: \.valenceString),
            .init(name: "Acoustics", lowerLabel: "Digital", higherLabel: "Analog",
                  keyPath: \.acousticness, descriptionKeyPath: \.acousticnessString)
        ]
    }
}
