//
//  FeaturesHelper.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 09/06/2022.
//

import Foundation

public class FeaturesHelper {
    
    static public func getAnalysedTracks(tracks: [Track]) -> [Track] {
        tracks.filter { track in
            track.audioFeatures != nil
        }
    }
    
    static public func getUnAnalysedTracks(tracks: [Track]) -> [Track] {
        tracks.filter { track in
            track.audioFeatures == nil
        }
    }
    
}
