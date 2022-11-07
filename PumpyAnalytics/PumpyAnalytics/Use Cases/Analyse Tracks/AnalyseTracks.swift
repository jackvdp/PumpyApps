//
//  AnalyseTracks.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/08/2022.
//

import Foundation

class AnalyseTracks {
    
    func execute(tracks: [Track], authManager: AuthorisationManager, completion: @escaping ([Track]) -> ()) {
        GetAudioFeaturesAndSpotifyItem().forPlaylist(tracks: tracks, authManager: authManager)
        subscribeToTracks(tracks: tracks, completion: completion)
    }
    
    func subscribeToTracks(tracks: [Track], completion: @escaping ([Track]) -> ()) {
        let nc = NotificationCenter.default
        var observer: NSObjectProtocol?
        observer = nc.addObserver(forName: .TracksGotAnalysed, object: nil, queue: nil) { _ in
            
            let tracksStillAnalysing = tracks.filter { $0.inProgress.analysing }
            
            if tracksStillAnalysing.isEmpty {
                nc.removeObserver(observer as Any)
                completion(tracks)
            }
            
        }
    }
    
}
