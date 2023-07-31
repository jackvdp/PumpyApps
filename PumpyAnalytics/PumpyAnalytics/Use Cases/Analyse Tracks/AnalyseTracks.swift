//
//  AnalyseTracks.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/08/2022.
//

import Foundation

class AnalyseTracks {
    
    let getSpotifyItemUseCase = GetAudioFeaturesAndSpotifyItem()
    var observer: NSObjectProtocol?
    
    func execute(tracks: [Track], authManager: AuthorisationManager, completion: @escaping ([Track]) -> ()) {
        getSpotifyItemUseCase.forPlaylist(tracks: tracks, authManager: authManager)
        subscribeToTracks(tracks: tracks, completion: completion)
    }
    
    func subscribeToTracks(tracks: [Track], completion: @escaping ([Track]) -> ()) {
        let nc = NotificationCenter.default
        observer = nc.addObserver(forName: .TracksGotAnalysed, object: nil, queue: nil) { [weak self] obs in
            guard let self else { return }
            let tracksStillAnalysing = tracks.filter { $0.inProgress.analysing }
            
            if tracksStillAnalysing.isEmpty {
                nc.removeObserver(self.observer as Any)
                completion(tracks)
            }
            
        }
    }
    
}
