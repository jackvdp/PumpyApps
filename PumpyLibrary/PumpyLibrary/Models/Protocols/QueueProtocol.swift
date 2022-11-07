//
//  QueueManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol QueueProtocol: ObservableObject {
    var queueIndex: Int { get set }
    var queueTracks: [ConstructedTrack] { get set }
    var analysingEnergy: Bool { get set }
    func removeFromQueue(id: String)
    func increaseEnergy()
    func decreaseEnergy()
    func addTrackToQueue(ids: [String])
    func playTrackNow(id: String)
}

class MockQueueManager: QueueProtocol {
    var queueIndex = 0
    var queueTracks = [ConstructedTrack]()
    var analysingEnergy: Bool = false
    func removeFromQueue(id: String) {}
    func increaseEnergy() {}
    func decreaseEnergy() {}
    func addTrackToQueue(ids: [String]) {}
    func playTrackNow(id: String) {}
}
