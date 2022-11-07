//
//  NowPlayingProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import UIKit
import MusicKit

public protocol NowPlayingProtocol: ObservableObject {
    var playButtonState: PlayButton { get set }
    var currentTrack: ConstructedTrack? { get set }
    var currentArtwork: UIImage? { get set }
}

class MockNowPlayingManager: NowPlayingProtocol {
    var playButtonState: PlayButton = .notPlaying
    var currentTrack: ConstructedTrack? = nil
    var currentArtwork: UIImage? = nil
}
