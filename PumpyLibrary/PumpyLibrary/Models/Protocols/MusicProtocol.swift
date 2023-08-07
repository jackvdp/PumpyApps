//
//  MusicManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 11/08/2022.
//

import Foundation
import PumpyAnalytics

public protocol MusicProtocol: ObservableObject {
    associatedtype P: PlaylistProtocol
    associatedtype Q: QueueProtocol
    associatedtype B: BlockedTracksProtocol
    
    var authManager: AuthorisationManager? { get }
    var playlistManager: P? { get }
    var queueManager: Q? { get }
    var blockedTracksManager: B? { get }
    var settingsManager: SettingsManager? { get }
    var username: Username? { get }
}

public class MockMusicMananger: MusicProtocol {
     
    public typealias P = MockPlaylistManager
    
    public typealias Q = MockQueueManager
    
    public typealias B = MockBlockedTracks
    
    public var authManager: AuthorisationManager?
    
    public var playlistManager: MockPlaylistManager? = MockPlaylistManager()
    
    public var queueManager: MockQueueManager? = MockQueueManager()
    
    public var blockedTracksManager: MockBlockedTracks? = MockBlockedTracks()
    
    public var settingsManager: SettingsManager? = SettingsManager()
    
    public var username: Username? = .account("test")
    
}
