//
//  NowPlayingProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation
import PumpyAnalytics
import UIKit

public protocol NowPlayingProtocol: ObservableObject {
    var playButtonState: PlayButton { get set }
    var currentTrack: Track? { get }
    var currentArtwork: UIImage? { get }
    var currentAnalyticsTrack: PumpyAnalytics.Track? { get }
}

class MockNowPlayingManager: NowPlayingProtocol {
    var playButtonState: PlayButton = .notPlaying
    @Published var currentTrack: Track? = nil
    var currentArtwork: UIImage?
    var currentAnalyticsTrack: PumpyAnalytics.Track? = nil
}
