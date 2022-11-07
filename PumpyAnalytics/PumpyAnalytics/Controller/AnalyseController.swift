//
//  AnalyzeController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/08/2022.
//

import Foundation

public class AnalyseController {
    
    public init() {}
    
    public func analyseTracks(tracks: [Track], authManager: AuthorisationManager, completion: @escaping ([Track]) -> ()) {
        AnalyseTracks().execute(tracks: tracks,
                                authManager: authManager,
                                completion: completion)
    }
    
    public func analyseMediaPlayerTracks(amIDs: [String],
                                         authManager: AuthorisationManager,
                                         completion: @escaping ([Track])->()) {
        AnalyseMediaPlayerTracks().execute(ids: amIDs,
                                           authManager: authManager,
                                           completion: completion)
    }
    
}
