//
//  AnalyzeController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/08/2022.
//

import Foundation

public class AnalyseController {
    
    public init() {}
    
    private lazy var getSpotifyItemUseCase = GetAudioFeaturesAndSpotifyItem()
    private lazy var analyseMediaPlayerTracksUseCase = AnalyseMediaPlayerTracks()
    
    public func analyseTracks(tracks: [Track], authManager: AuthorisationManager) async {
        await getSpotifyItemUseCase.forPlaylist(tracks: tracks, authManager: authManager)
    }
    
    /// Analyse media player tracks. In contrast to the above method it also gets the isrc number
    public func analyseMediaPlayerTracks(tracks: [Track], authManager: AuthorisationManager) async {
        await analyseMediaPlayerTracksUseCase.execute(tracks: tracks, authManager: authManager)
    }
    
}
