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
    
    @Published private(set) var seedTracks = [PumpyAnalytics.Track]() {
        didSet {
            setAverages()
        }
    }
    var playlistTrackslimit = 50
    let model = MusicLabModel()
    let controller = PlaylistController()
    
    var properties: [SeedAttributes] = [
        .init(name: "Popularity", lowerLabel: "Playing at bars", higherLabel: "World Tour",
              keyPath: nil, descriptionKeyPath: nil),
        .init(name: "Energy", lowerLabel: "Chill", higherLabel: "Buzzing",
              keyPath: \.energy, descriptionKeyPath: \.energyString),
        .init(name: "Vocals", lowerLabel: "None", higherLabel: "A ton",
              keyPath: \.instrumentalness, descriptionKeyPath: \.instrumentalnessString),
        .init(name: "BPM", lowerLabel: "Slow", higherLabel: "Fast",
              keyPath: \.tempo, descriptionKeyPath: \.tempoString),
        .init(name: "Danceable", lowerLabel: "Sitting down", higherLabel: "Disco",
              keyPath: \.danceability, descriptionKeyPath: \.danceabilityString),
        .init(name: "Mood", lowerLabel: "Downer", higherLabel: "Upper",
              keyPath: \.valence, descriptionKeyPath: \.valenceString),
        .init(name: "Acoustics", lowerLabel: "All digital", higherLabel: "All analog",
              keyPath: \.acousticness, descriptionKeyPath: \.acousticnessString)
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
    
    func createMix(authManager: AuthorisationManager, completion: @escaping (RecommendedPlaylist?) -> ()) {
        let seeding = model.transform(tracks: seedTracks, playlistSize: playlistTrackslimit, seedAttributes: properties)
        controller.createFromSuggestions(seeding: seeding,
                                         authManager: authManager) { playlist, error in
            completion(playlist)
            playlist?.getTracksData()
        }
    }
    
    var anyTracksHaveFeatures: Bool {
        seedTracks.filter { $0.audioFeatures != nil }.isNotEmpty
    }
    
    /// When a seed track gets added or removed, the averages need to be recalculated
    func setAverages() {
        for property in properties {
            property.setAverage(tracks: seedTracks)
        }
    }
    
}

class SeedAttributes: ObservableObject {
    internal init(name: String, lowerLabel: String, higherLabel: String,
                  keyPath: KeyPath<PumpyAnalytics.AudioFeatures, Float?>?, descriptionKeyPath: KeyPath<PumpyAnalytics.AudioFeatures, String>?) {
        self.name = name
        self.lowerLabel = lowerLabel
        self.higherLabel = higherLabel
        self.keyPath = keyPath
        self.descriptionKeyPath = descriptionKeyPath
    }
    
    var name: String
    var lowerLabel: String
    var higherLabel: String
    @Published var lowerValue: Double = 25
    @Published var higherValue: Double = 25
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
    }
}


