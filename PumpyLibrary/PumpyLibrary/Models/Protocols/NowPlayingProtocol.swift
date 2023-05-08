//
//  NowPlayingProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol NowPlayingProtocol: ObservableObject {
    var currentTrack: Track? { get }
}

public protocol PlayerStateProtocol: ObservableObject {
    var playButtonState: PlayButton { get set }
}

public class MockNowPlayingManager: NowPlayingProtocol {
    public var currentTrack: Track? {
        self.currentEntry
    }
    
    var playButtonState: PlayButton = .notPlaying
    var currentEntry: QueueTrack? = nil
}
