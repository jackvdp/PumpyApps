//
//  QueueManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation
import MusicKit

public protocol QueueProtocol: ObservableObject {
    var queueIndex: Int { get set }
    var queueTracks: [PumpyLibrary.Track] { get set }
    var analysingEnergy: Bool { get set }
    func getQueue()
    func removeFromQueue(id: String)
    func addTrackToQueue(ids: [String], playWhen position: Position)
    func increaseEnergy()
    func decreaseEnergy()
}

public class MockQueueManager: QueueProtocol {
    public var queueIndex = 0
    public var queueTracks = [PumpyLibrary.Track]()
    public var analysingEnergy: Bool = false
    public func removeFromQueue(id: String) {}
    public func increaseEnergy() {}
    public func decreaseEnergy() {}
    public func getQueue() {}
    public func addTrackToQueue(ids: [String], playWhen position: Position) {}
    
}
