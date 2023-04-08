//
//  MusicLabManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/03/2023.
//

import Foundation
import PumpyAnalytics
import SwiftUI

public class MusicLabManager: ObservableObject {

    public init() {}
    
    @Published private(set) var seedTracks = [PumpyAnalytics.Track]() {
        didSet {
            setAverages()
        }
    }
    var properties = SeedAttributes.defaultAttributes()
    private let controller = PlaylistController()
    
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
        let seeding = properties.transformToAnalyticsSeeding(tracks: seedTracks)
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
        withAnimation {
            for property in properties {
                property.setAverage(tracks: seedTracks)
            }
        }
    }
    
    // MARK: Enable/Disable Attributes
    
    func enableAllAttributes() {
        properties.forEach { attribute in
            attribute.active = true
        }
        objectWillChange.send()
    }
    
    func disableAllAttributes() {
        properties.forEach { attribute in
            attribute.active = false
        }
        objectWillChange.send()
    }
    
    var allTracksEnabled: Bool {
        properties.filter { $0.active == false }.count == 0
    }
    
    var allTracksDisabled: Bool {
        properties.filter { $0.active }.count == 0
    }
}


