//
//  TextPlaylist.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 31/10/2022.
//

import Foundation

public class TrackPlaylist: Hashable, Identifiable, Playlist {
    
    public var name: String?
    public var curator: String
    public var tracks: [Track]
    public var artworkURL: String?
    public var description: String?
    public var shortDescription: String?
    public var authManager: AuthorisationManager
    public var sourceID: String
    public var uuid = UUID()
    
    private lazy var getAudioFeaturesUseCase = GetAudioFeaturesAndSpotifyItem()
    private lazy var matchToAMUseCase = MatchToAM()
    
    public var snapshot: PlaylistSnapshot {
        PlaylistSnapshot(
            name: name,
            sourceID: sourceID,
            type: .text
        )
    }
    
    public init(name: String?, curator: String, tracks: [Track], artworkURL: String?, description: String?, shortDescription: String?, authManager: AuthorisationManager, sourceID: String) {
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
    
    public func getTracksData() {
        Task {
            await getAudioFeaturesUseCase.forPlaylist(tracks: tracks, authManager: authManager)
        }
        matchToAM()
    }
    
    public func matchToAM() {
        Task {
            await matchToAMUseCase.execute(tracks: tracks, authManager: authManager)
        }
    }
    
    public func removeDuplicates() {
        tracks = tracks.removingDuplicates()
    }

}

extension TrackPlaylist {
    public static func == (lhs: TrackPlaylist, rhs: TrackPlaylist) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

}
