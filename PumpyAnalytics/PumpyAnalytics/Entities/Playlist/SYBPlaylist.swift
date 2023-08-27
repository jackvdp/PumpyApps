//
//  SYBPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/03/2022.
//

import Foundation

public class SYBPlaylist: Hashable, Identifiable, Playlist {
    
    public var name: String?
    public var curator: String
    @Published public var tracks: [Track]
    public var artworkURL: String?
    public var description: String?
    public var shortDescription: String?
    public var sourceID: String
    public var uuid = UUID()
    public var authManager: AuthorisationManager
    
    private lazy var getAudioFeaturesUseCase = GetAudioFeaturesAndSpotifyItem()
    private lazy var matchToAMUseCase = MatchToAM()
    
    public var snapshot: PlaylistSnapshot {
        PlaylistSnapshot(name: name,
                        artworkURL: artworkURL,
                        shortDescription: shortDescription,
                        sourceID: sourceID,
                        type: .syb(id: sourceID)
        )
    }
    
    init(name: String?, curator: String, tracks: [Track], artworkURL: String?, description: String?, shortDescription: String?, sybID: String, authManager: AuthorisationManager) {
        self.name = name
        self.curator = curator
        self.tracks = tracks
        self.artworkURL = artworkURL
        self.description = description
        self.shortDescription = shortDescription
        self.sourceID = sybID
        self.authManager = authManager
        removeDuplicates()
    }
    
    private var matchTask: Task<(), Never>?
    private var feautresTask: Task<(), Never>?
    
    public func getTracksData() {
        feautresTask = Task {
            await getAudioFeaturesUseCase.forPlaylist(tracks: tracks, authManager: authManager)
        }
        matchToAM()
    }
    
    public func matchToAM() {
        matchTask = Task {
            await matchToAMUseCase.execute(tracks: tracks, authManager: authManager)
        }
    }
        
    public func removeDuplicates() {
        tracks = tracks.removingDuplicates()
    }
    
    public func cancelTasks() {
        matchTask?.cancel()
        feautresTask?.cancel()
        matchTask = nil
        feautresTask = nil
    }
}

extension SYBPlaylist {
    
    public static func == (lhs: SYBPlaylist, rhs: SYBPlaylist) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}
