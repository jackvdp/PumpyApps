//
//  SpotPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 07/05/2022.
//

import Foundation

public class SpotifyPlaylist: Hashable, Identifiable, Playlist {
    
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
    private lazy var matchToAMUseCase = MatchToAM()
    
    public var snapshot: PlaylistSnapshot {
        PlaylistSnapshot(name: name,
                        artworkURL: artworkURL,
                        shortDescription: shortDescription,
                        sourceID: sourceID,
                        type: .spotify(id: sourceID))
    }
    
    init(name: String?, curator: String, tracks: [Track], artworkURL: String?, description: String?, shortDescription: String?, sourceID: String, authManager: AuthorisationManager) {
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
            async let featuresResponse: () = getAudioFeaturesUseCase.forPlaylist(tracks: tracks, authManager: authManager)
            async let matchResponse: () = matchToAMUseCase.execute(tracks: tracks, authManager: authManager)
            let (_, _) = await (featuresResponse, matchResponse)
        }
    }
        
    public func removeDuplicates() {
        tracks = tracks.removingDuplicates()
    }
}

extension SpotifyPlaylist {
    
    public static func == (lhs: SpotifyPlaylist, rhs: SpotifyPlaylist) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}
