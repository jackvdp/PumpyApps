//
//  AlbumController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/09/2022.
//

import Foundation

public class AlbumController {
    
    public init() {}
    
    private let useCase = GetAMAlbum()
    
    public func get(albumID: String,
                    authManager: AuthorisationManager,
                    completion: @escaping (AMAlbum?, ErrorMessage?) -> ()) {
        
        useCase.execute(id: albumID,
                        authManager: authManager,
                        completion: completion)
        
    }
    
}
