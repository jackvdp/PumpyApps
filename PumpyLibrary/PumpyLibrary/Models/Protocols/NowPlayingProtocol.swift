//
//  NowPlayingProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol NowPlayingProtocol: ObservableObject {
    var playButtonState: PlayButton { get set }
    var currentTrack: Track? { get }
}

class MockNowPlayingManager: NowPlayingProtocol {
    var playButtonState: PlayButton = .notPlaying
    @Published var currentTrack: Track? = nil
}
