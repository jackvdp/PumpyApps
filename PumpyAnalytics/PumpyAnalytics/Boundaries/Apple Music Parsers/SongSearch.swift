//
//  SongSearch.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 15/09/2022.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SongSearchResults: Codable {
    let results: WelcomeResults
    let meta: Meta
    
    // MARK: - Meta
    struct Meta: Codable {
        let results: MetaResults
    }

    // MARK: - MetaResults
    struct MetaResults: Codable {
        let order, rawOrder: [Order]
    }

    enum Order: String, Codable {
        case songs = "songs"
    }

    // MARK: - WelcomeResults
    struct WelcomeResults: Codable {
        let songs: Songs
    }

    // MARK: - Songs
    struct Songs: Codable {
        let href, next: String
        let data: [Datum]
    }

    // MARK: - Datum
    struct Datum: Codable {
        let id: String
        let type: Order
        let href: String
        let attributes: Attributes
    }

    // MARK: - Attributes
    struct Attributes: Codable {
        let albumName: String
        let genreNames: [String]
        let trackNumber: Int
        let releaseDate: String?
        let durationInMillis: Int
        let isrc: String
        let artwork: Artwork
        let composerName: String?
        let url: String
        let playParams: PlayParams
        let discNumber: Int
        let isAppleDigitalMaster, hasLyrics: Bool
        let name: String
        let previews: [Preview]
        let artistName: String
        let contentRating: String?
    }

    // MARK: - Artwork
    struct Artwork: Codable {
        let width, height: Int
        let url, bgColor, textColor1, textColor2: String
        let textColor3, textColor4: String
    }

    // MARK: - PlayParams
    struct PlayParams: Codable {
        let id: String
        let kind: Kind
    }

    enum Kind: String, Codable {
        case song = "song"
    }

    // MARK: - Preview
    struct Preview: Codable {
        let url: String
    }
}



