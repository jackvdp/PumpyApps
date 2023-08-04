//
//  BookmarkedItem.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 03/08/2023.
//

import Foundation
import PumpyAnalytics

enum BookmarkedItem: Codable, Hashable {
    case track(CodableTrack), playlist(PlaylistSnapshot)

    var id: String {
        switch self {
        case .track(let blockedTrack):
            return blockedTrack.playbackID
        case .playlist(let playlistSnapshot):
            return playlistSnapshot.sourceID
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let playlist = try? container.decode(PlaylistSnapshot.self) {
            self = .playlist(playlist)
        } else if let track = try? container.decode(CodableTrack.self) {
            self = .track(track)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode item")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        if case let .playlist(playlist) = self {
            try container.encode(playlist)
        } else if case let .track(track) = self  {
            try container.encode(track)
        }
    }
}
