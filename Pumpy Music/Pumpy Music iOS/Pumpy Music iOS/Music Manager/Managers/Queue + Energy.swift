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
        guard queueIndex + 1 < queueTracks.count && queueIndex >= 0 else { return }
        guard let authManager = authManager else { return }
        let ids = queueTracks[queueIndex+1..<queueTracks.count].compactMap { $0.amStoreID }
        AnalyseController().analyseMediaPlayerTracks(amIDs: ids,
                                                     authManager: authManager) { [weak self] analysedTracks in
            DispatchQueue.main.async {
                self?.analysingEnergy = false
            }
            completion(analysedTracks)
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
        for item in controller.queue.entries {
            if tracksToKeepIds.contains(item.id) {
                controller.queue.entries.removeAll(where: { $0.id == item.id })
            }
        }
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
