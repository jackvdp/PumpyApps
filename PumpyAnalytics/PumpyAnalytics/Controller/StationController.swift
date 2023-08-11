//
//  StationController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 10/08/2023.
//

import Foundation

public class StationController {
    
    public init() {}
    
    private let useCase = GetStationUseCase()
    
    /// Returns an Apple Music station with 10 songs for the given station ID
    public func get(stationID: String,
                    authManager: AuthorisationManager,
                    completion: @escaping (AMStation?, ErrorMessage?) -> ()) {
        useCase.execute(stationID: stationID, authManager: authManager, completion: completion)
    }
    
}

