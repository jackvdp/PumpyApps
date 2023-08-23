//
//  Queue + Energy.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import PumpyAnalytics
import MusicKit
import MediaPlayer
import PumpyLibrary

extension QueueManager {
    
    func increaseEnergy() {
        analyseQueue() { [weak self] tracks in
            guard let self = self else { return }
            let (mostEnergy, _) = self.sortTracksByEnergy(tracks: tracks)
            let items = self.matchTracksToQueueItems(tracks: mostEnergy)
            self.removeUnwantedAnalysedTracks(items)
        }
    }
    
    func decreaseEnergy() {
        analyseQueue() { [weak self] tracks in
            guard let self = self else { return }
            let (_, leastEnergy) = self.sortTracksByEnergy(tracks: tracks)
            let items = self.matchTracksToQueueItems(tracks: leastEnergy)
            self.removeUnwantedAnalysedTracks(items)
        }
    }
    
    private func analyseQueue(completion: @escaping ([PumpyAnalytics.Track])->()) {
        analysingEnergy = true
        guard queueIndex + 1 < queueTracks.count && queueIndex >= 0,
              let authManager = authManager else { return }
        let tracks = queueTracks[queueIndex+1..<queueTracks.count].compactMap { $0.analyticsTrack(authManager: authManager) }
        Task {
            await analyseController.analyseMediaPlayerTracks(tracks: tracks, authManager: authManager)
            await MainActor.run {
                analysingEnergy = false
            }
            completion(tracks)
        }
    }
    
    // MARK: - Set queue with new items
    
    private func matchTracksToQueueItems(tracks: [PumpyAnalytics.Track]) -> [PumpyLibrary.Track] {
        return queueTracks.filter { item in
            tracks.contains(where: { track in
                track.sourceID == item.amStoreID
            })
        }
    }
    
    private func removeUnwantedAnalysedTracks(_ tracks: [PumpyLibrary.Track]) {
        let tracksToKeepIds = tracks.map { $0.amStoreID }
        conductQueuePerform { mutableQueue in
            for item in mutableQueue.items {
                if tracksToKeepIds.contains(item.playbackStoreID) {
                    mutableQueue.remove(item)
                }
            }
        } completion: { _, _ in }
    }
    
    // MARK: - Sort tracks by energy
    
    private func sortTracksByEnergy(tracks: [PumpyAnalytics.Track]) -> (mostEnergyIDs: [PumpyAnalytics.Track],
                                                                        leastEnergyIDs: [PumpyAnalytics.Track]) {
        let analysedTracks = tracks.filter { $0.audioFeatures?.energy != nil }
        print(tracks.count)
        print(analysedTracks.count)
        let sortedTracks = analysedTracks.sorted(by: {
            $0.audioFeatures?.energy ?? 0 > $1.audioFeatures?.energy ?? 0
        })
        
        let pair = sortedTracks.split(into: 2)
        return (mostEnergyIDs: pair.first ?? [], leastEnergyIDs: pair.last ?? [])
    }
}
