//
//  SearchSuggestions.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 22/04/2023.
//

import Foundation

// MARK: - SearchSuggestions
public struct SearchSuggestions: Codable {
    public let results: Results
}

// MARK: - Results
public struct Results: Codable {
    public let suggestions: [Suggestion]
}

// MARK: - Suggestion
public struct Suggestion: Codable {
    public let kind, searchTerm, displayTerm: String
}
