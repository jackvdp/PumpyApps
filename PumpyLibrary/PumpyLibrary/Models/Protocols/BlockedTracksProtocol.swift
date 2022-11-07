//
//  BlockedTracksProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol BlockedTracksProtocol: ObservableObject {
    var blockedTracks: [BlockedTrack] { get set }
    func unblockTrackOrAskToBlock(track: BlockedTrack) -> Bool
    func addTrackToBlockedList(_ track: BlockedTrack)
}

public class MockBlockedTracks: BlockedTracksProtocol {
    public init() {}
    public var blockedTracks = [BlockedTrack]()
    public func unblockTrackOrAskToBlock(track: BlockedTrack) -> Bool {return false}
    public func addTrackToBlockedList(_ track: BlockedTrack) {}
}
