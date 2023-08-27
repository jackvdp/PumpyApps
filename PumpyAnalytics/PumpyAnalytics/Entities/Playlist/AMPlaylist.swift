//
//  AMPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/04/2022.
//

import Foundation

public class AMPlaylist: Hashable, Identifiable, Playlist {
    
    public var name: String?
    public var curator: String
    public var tracks: [Track]
    public var artworkURL: String?
    public var description: String?
    public var shortDescription: String?
    public var sourceID: String
    public var uuid = UUID()
    public var authManager: AuthorisationManager
    
    private lazy var getAudioFeaturesUseCase = GetAudioFeaturesAndSpotifyItem()
    
    public var snapshot: PlaylistSnapshot {
        PlaylistSnapshot(name: name,
                        artworkURL: artworkURL,
                        shortDescription: shortDescription,
                        sourceID: sourceID,
                        type: .am(id: sourceID))
    }
    
    public init(name: String?, curator: String, tracks: [Track], artworkURL: String?, description: String?, shortDescription: String?, sourceID: String, authManager: AuthorisationManager) {
        self.name = name
        self.curator = curator
        self.tracks = tracks
        self.artworkURL = artworkURL
        self.description = description
        self.shortDescription = shortDescription
        self.authManager = authManager
        self.sourceID = sourceID
        removeDuplicates()
    }
    
    private var feautresTask: Task<(), Never>?
    
    public func getTracksData() {
        feautresTask = Task {
            await getAudioFeaturesUseCase.forPlaylist(tracks: tracks, authManager: authManager)
        }
    }
    
    public func matchToAM() {}
        
    public func removeDuplicates() {
        tracks = tracks.removingDuplicates()
    }
    
    public func cancelTasks() {
        feautresTask?.cancel()
        feautresTask = nil
    }
}

extension AMPlaylist {
    
    public static func == (lhs: AMPlaylist, rhs: AMPlaylist) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}
