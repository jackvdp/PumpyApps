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

public class MockQueueManager: QueueProtocol {
    public var queueIndex = 0
    public var queueTracks = [ConstructedTrack]()
    public var analysingEnergy: Bool = false
    public func removeFromQueue(id: String) {}
    public func increaseEnergy() {}
    public func decreaseEnergy() {}
    public func addTrackToQueue(ids: [String]) {}
    public func playTrackNow(id: String) {}
}
