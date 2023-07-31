//
//  Recommendations.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 03/09/2022.
//

import Foundation

public struct SuggestedCollection: Hashable, Codable {
    public init(title: String, items: [SuggestedItem], types: [SuggestedType]) {
        self.title = title
        self.items = items
        self.types = types
    }
    
    public var title: String
    public var items: [SuggestedItem]
    public var types: [SuggestedType]
    var id = UUID().uuidString
    
    public static func == (lhs: SuggestedCollection, rhs: SuggestedCollection) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct SuggestedItem: Codable {
    public var name: String
    public var id: String
    public var type: SuggestedType
    public var artworkURL: String
    public var curator: String
}

public enum SuggestedType: String, Codable {
    case albums, playlists
}

