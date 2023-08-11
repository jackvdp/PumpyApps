//
//  Station.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 11/08/2023.
//

import Foundation
import MusicKit

struct Stations: Codable {
    let data: [Station]
}

// MARK: - StationTracks
struct StationTracks: Codable {
    let data: [Datum]
}

extension StationTracks {
    
    // MARK: - Datum
    struct Datum: Codable {
        let id, type, href: String
        let attributes: Attributes
    }

    // MARK: - Attributes
    struct Attributes: Codable {
        let albumName: String
        let genreNames: [String]
        let trackNumber, durationInMillis: Int
        let releaseDate, isrc: String
        let artwork: Artwork
        let composerName: String
        let url: String
        let playParams: PlayParams
        let playAssets: [PlayAsset]
        let discNumber: Int
        let hasCredits, hasLyrics, isAppleDigitalMaster: Bool
        let name: String
        let previews: [Preview]
        let artistName: String
    }

    // MARK: - Artwork
    struct Artwork: Codable {
        let width, height: Int
        let url, bgColor, textColor1, textColor2: String
        let textColor3, textColor4: String
    }

    // MARK: - PlayAsset
    struct PlayAsset: Codable {
        let url: String
        let bitRate: Int
    }

    // MARK: - PlayParams
    struct PlayParams: Codable {
        let id, kind: String
    }

    // MARK: - Preview
    struct Preview: Codable {
        let url: String
    }
}

