//
//  CustomPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/03/2022.
//

import Foundation

public class CustomPlaylist: Hashable, Identifiable, Playlist {
    
    public var name: String?
    public var curator: String
    public var tracks: [Track]
    public var artworkURL: String?
    public var description: String?
    public var shortDescription: String?
    public var authManager: AuthorisationManager
    public var sourceID: String
    public var uuid = UUID()
    public var playlistLogic: CustomPlaylistLogic
    
    public var snapshot: PlaylistSnapshot {
        PlaylistSnapshot(
            name: name,
            sourceID: sourceID,
            type: .custom(playlistLogic)
        )
    }
    
    private lazy var getAudioFeaturesUseCase = GetAudioFeaturesAndSpotifyItem()
    private lazy var matchToAMUseCase = MatchToAM()
    
    public init(name: String?, curator: String, tracks: [Track], artworkURL: String?, description: String?, shortDescription: String?, logic: CustomPlaylistLogic, authManager: AuthorisationManager, sourceID: String) {
        self.name = name
        self.curator = curator
        self.tracks = tracks
        self.artworkURL = artworkURL
        self.description = description
        self.shortDescription = shortDescription
        self.authManager = authManager
        self.sourceID = sourceID
        self.playlistLogic = logic
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

extension CustomPlaylist {
    public static func == (lhs: CustomPlaylist, rhs: CustomPlaylist) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

}

public struct CustomPlaylistLogic: Codable {
    
    public init(snapshots: [PlaylistSnapshot], index: Int = 0, divideBy: DivideBy = .one, sortBy: SortTracks = .bpm) {
        self.snapshots = snapshots
        self.index = index
        self.divideBy = divideBy
        self.sortBy = sortBy
    }
    
    public var snapshots: [PlaylistSnapshot]
    public var index: Int
    public var divideBy: DivideBy
    public var sortBy: SortTracks
    
}

public enum DivideBy: Int, CaseIterable, Identifiable, Codable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    
    public var id: Self { self }
}
