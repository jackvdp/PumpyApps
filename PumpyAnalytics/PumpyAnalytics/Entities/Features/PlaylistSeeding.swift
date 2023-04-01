//
//  CreatePlaylistSeeding.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/06/2022.
//

import Foundation
import SwiftUI

public struct PlaylistSeeding {
    public init(trackIDs: [String], artistIDs: [String], genres: [String], playlistSize: Int, seeding: AttributeSeeding) {
        self.trackIDs = trackIDs
        self.artistIDs = artistIDs
        self.genres = genres
        self.playlistSize = playlistSize
        self.seeding = seeding
    }
    
    public var trackIDs: [String]
    public var artistIDs: [String]
    public var genres: [String]
    public var playlistSize: Int
    public var seeding: AttributeSeeding
}

public struct AttributeSeeding {
    public init(maxDanceability: Double?,
                minDanceability: Double?,
                maxEnergy: Double?,
                minEnergy: Double?,
                maxPopularity: Int?,
                minPopularity: Int?,
                maxBPM: Int?,
                minBPM: Int?,
                maxHappiness: Double?,
                minHappiness: Double?,
                maxLoudness: Int?,
                minLoudness: Int?,
                maxInstrumnetalness: Double?,
                minInstrumnetalness: Double?,
                maxAcoustic: Double?,
                minAcoustic: Double?) {
        self.maxDanceability = maxDanceability
        self.minDanceability = minDanceability
        self.maxEnergy = maxEnergy
        self.minEnergy = minEnergy
        self.maxPopularity = maxPopularity
        self.minPopularity = minPopularity
        self.maxBPM = maxBPM
        self.minBPM = minBPM
        self.maxHappiness = maxHappiness
        self.minHappiness = minHappiness
        self.maxLoudness = maxLoudness
        self.minLoudness = minLoudness
        self.maxInstrumentalness = maxInstrumnetalness
        self.minInstrumentalness = minInstrumnetalness
        self.maxAcoustic = maxAcoustic
        self.minAcoustic = minAcoustic
    }
    
    public var maxDanceability: Double?
    public var minDanceability: Double?
    
    public var maxEnergy: Double?
    public var minEnergy: Double?
    
    public var maxPopularity: Int?
    public var minPopularity: Int?
    
    public var maxBPM: Int?
    public var minBPM: Int?
    
    public var maxHappiness: Double?
    public var minHappiness: Double?
    
    public var maxLoudness: Int?
    public var minLoudness: Int?
    
    public var maxInstrumentalness: Double?
    public var minInstrumentalness: Double?
    
    public var maxAcoustic: Double?
    public var minAcoustic: Double?
}
