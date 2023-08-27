//
//  MusicModels.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/02/2022.
//

import Foundation

public protocol Playlist {

    var name: String? { get set }
    var curator: String { get set }
    var tracks: [Track] { get set }
    var artworkURL: String? { get set }
    var description: String? { get set }
    var shortDescription: String? { get set }
    var authManager: AuthorisationManager { get set }
    var sourceID: String { get set }
    var uuid: UUID { get set }
    var snapshot: PlaylistSnapshot { get }
    
    func getTracksData()
    func matchToAM()
    
    func removeDuplicates()
    
    func cancelTasks()
}


