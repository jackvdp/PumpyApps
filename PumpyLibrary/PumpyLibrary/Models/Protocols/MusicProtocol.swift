//
//  MusicManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 11/08/2022.
//

import Foundation

public protocol MusicProtocol: ObservableObject {
    associatedtype T: TokenProtocol
    associatedtype P: PlaylistProtocol
    associatedtype Q: QueueProtocol
    associatedtype B: BlockedTracksProtocol
    
    var authManager: T { get }
    var playlistManager: P { get }
    var queueManager: Q { get }
    var blockedTracksManager: B { get }
    var settingsManager: SettingsManager? { get }
    var username: String { get }
}

class MockMusicMananger: MusicProtocol {
    typealias T = MockTokenManager
    
    typealias P = MockPlaylistManager
    
    typealias Q = MockQueueManager
    
    typealias B = MockBlockedTracks
    
    var authManager: MockTokenManager = MockTokenManager()
    
    var playlistManager: MockPlaylistManager = MockPlaylistManager()
    
    var queueManager: MockQueueManager = MockQueueManager()
    
    var blockedTracksManager: MockBlockedTracks = MockBlockedTracks()
    
    var settingsManager: SettingsManager? = SettingsManager(username: "Test")
    
    var username: String = "Test"
    
}
