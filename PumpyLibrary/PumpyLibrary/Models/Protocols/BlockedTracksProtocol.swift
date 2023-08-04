//
//  BlockedTracksProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol BlockedTracksProtocol: ObservableObject {
    var blockedTracks: [CodableTrack] { get set }
    func unblockTrackOrAskToBlock(track: CodableTrack?) -> Bool
    func addTrackToBlockedList(_ track: CodableTrack)
    func removeTrack(id: String)
}

public class MockBlockedTracks: BlockedTracksProtocol {
    public init() {}
    public var blockedTracks = [CodableTrack]()
    public func unblockTrackOrAskToBlock(track: CodableTrack?) -> Bool {return false}
    public func addTrackToBlockedList(_ track: CodableTrack) {}
    public func removeTrack(id: String) {}
}
