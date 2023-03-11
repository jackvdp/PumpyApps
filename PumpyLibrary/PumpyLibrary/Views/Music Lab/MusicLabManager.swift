//
//  MusicLabManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/03/2023.
//

import Foundation
import PumpyAnalytics

public class MusicLabManager: ObservableObject {
    
    public init() {}
    
    @Published private(set) var seedTracks = [PumpyAnalytics.Track]()
    var playlistTrackslimit = 50
    
    @Published var properties: [SeedAttributes] = [
        .init(name: "Popularity", lowerLabel: "Playing at bars", higherLabel: "World Tour", keyPath: \.energyString),
        .init(name: "Energy", lowerLabel: "Chill", higherLabel: "Buzzing", keyPath: \.energyString),
        .init(name: "Vocals", lowerLabel: "None", higherLabel: "A ton", keyPath: \.instrumentalnessString),
        .init(name: "BPM", lowerLabel: "Slow", higherLabel: "Fast", keyPath: \.tempoString),
        .init(name: "Danceable", lowerLabel: "Sitting down", higherLabel: "Disco", keyPath: \.danceabilityString),
        .init(name: "Mood", lowerLabel: "Downer", higherLabel: "Upper", keyPath: \.valenceString),
        .init(name: "Acoustics", lowerLabel: "All digital", higherLabel: "All analog", keyPath: \.acousticnessString)
    ]
    
    /// Add new track to seed items. If seed tracks is already at capacity (count of 5), the first item will be removed
    func addTrack(_ track: PumpyAnalytics.Track) {
        seedTracks.append(track)
        
        if seedTracks.count > 5 {
            seedTracks.removeFirst()
        }
    }
    
    func removeTrack(at offsets: IndexSet) {
        seedTracks.remove(atOffsets: offsets)
    }
    
    func removeTrack(_ track: PumpyAnalytics.Track) {
        seedTracks.removeAll { trk in
            track.sourceID == trk.sourceID
        }
    }
    
    func includes(track: PumpyAnalytics.Track) -> Bool {
        seedTracks.contains { trk in
            track.sourceID == trk.sourceID
        }
    }
    
    func createMix() {
        //
    }
    
    var anyTracksHaveFeatures: Bool {
        seedTracks.filter { $0.audioFeatures != nil }.isNotEmpty
    }
    
}

struct SeedAttributes {
    var name: String
    var lowerLabel: String
    var higherLabel: String
    var lowerValue: Double = 25
    var higherValue: Double = 25
    var active: Bool = true
    var keyPath: KeyPath<PumpyAnalytics.AudioFeatures, String>
}
