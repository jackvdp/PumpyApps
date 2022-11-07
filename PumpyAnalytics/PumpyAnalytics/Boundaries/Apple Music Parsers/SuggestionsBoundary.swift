//
//  Recommendations.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 02/09/2022.
//

import Foundation

// MARK: - SuggestionBoundary
struct Suggestions: Codable {
    let data: [SuggestionBoundaryDatum]
    
    // MARK: - SuggestionBoundaryDatum
    struct SuggestionBoundaryDatum: Codable {
        let id, type, href: String
        let attributes: PurpleAttributes
        let relationships: Relationships
    }

    // MARK: - PurpleAttributes
    struct PurpleAttributes: Codable {
        let isGroupRecommendation: Bool
        let resourceTypes: [ResourceTypeElement]
        let nextUpdateDate: String
        let title: Title
        let kind: String
        let reason: Reason?
    }
    
    enum ResourceTypeElement: String, Codable {
        case albums = "albums"
        case playlists = "playlists"
        case stations = "stations"
        
        var publicType: SuggestedType? {
            switch self {
            case .playlists:
                return SuggestedType.playlists
            case .albums:
                return SuggestedType.albums
            case .stations:
                return nil
            }
        }
    }

    // MARK: - Reason
    struct Reason: Codable {
        let stringForDisplay: String
    }

    // MARK: - Title
    struct Title: Codable {
        let stringForDisplay: String
        let contentIDS: [String]?

        enum CodingKeys: String, CodingKey {
            case stringForDisplay
            case contentIDS = "contentIds"
        }
    }

    // MARK: - Relationships
    struct Relationships: Codable {
        let contents: Contents
    }

    // MARK: - Contents
    struct Contents: Codable {
        let href: String
        let data: [ContentsDatum]
    }

    // MARK: - ContentsDatum
    struct ContentsDatum: Codable {
        let id, href: String
        let type: ResourceTypeElement
        let attributes: FluffyAttributes
    }

    // MARK: - FluffyAttributes
    struct FluffyAttributes: Codable {
        let curatorName, lastModifiedDate: String?
        let isChart: Bool?
        let name: String
        let attributesDescription: Description?
        let playlistType: String?
        let artwork: Artwork
        let playParams: PlayParams
        let url: String
        let copyright: String?
        let genreNames: [String]?
        let releaseDate: String?
        let isMasteredForItunes: Bool?
        let upc, recordLabel: String?
        let trackCount: Int?
        let isCompilation, isSingle: Bool?
        let artistName, contentRating: String?
        let isComplete: Bool?
        let editorialNotes: EditorialNotes?
        let isLive: Bool?
        let mediaKind: String?

        enum CodingKeys: String, CodingKey {
            case curatorName, lastModifiedDate, isChart, name
            case attributesDescription = "description"
            case playlistType, artwork, playParams, url, copyright, genreNames, releaseDate, isMasteredForItunes, upc, recordLabel, trackCount, isCompilation, isSingle, artistName, contentRating, isComplete, editorialNotes, isLive, mediaKind
        }
    }

    // MARK: - Artwork
    struct Artwork: Codable {
        let width, height: Int
        let url: String
        let bgColor, textColor1, textColor2, textColor3: String?
        let textColor4: String?
    }

    // MARK: - Description
    struct Description: Codable {
        let standard: String
        let short: String?
    }

    // MARK: - EditorialNotes
    struct EditorialNotes: Codable {
        let standard, short, name: String?
    }

    // MARK: - PlayParams
    struct PlayParams: Codable {
        let id, kind: String
        let versionHash, format, stationHash: String?
        let hasDRM: Bool?
        let mediaType: Int?

        enum CodingKeys: String, CodingKey {
            case id, kind, versionHash, format, stationHash
            case hasDRM = "hasDrm"
            case mediaType
        }
    }

}
