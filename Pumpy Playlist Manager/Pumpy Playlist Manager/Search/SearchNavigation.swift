//
//  SearchNavigation.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 03/03/2022.
//

import Foundation
import PumpyAnalytics

class SearchNavigationManager: NavigationManager {
    @Published var currentPage: SearchNavigation = .search
}

enum SearchNavigation: NavigationSection, Equatable {
        
    case search
    case playlist(PlaylistSnapshot)

    func defaultPage() -> SearchNavigation {
        return .search
    }
    
    func headerTitle() -> String {
        switch self {
        case .search:
            return "Search"
        case .playlist(let playlist):
            return playlist.name ?? "Playlist"
        }
    }
    
    func previousPage() -> SearchNavigation? {
        switch self {
        case .search:
            return nil
        case .playlist(_):
            return .search
        }
    }
    
    static func ==(lhs: SearchNavigation, rhs: SearchNavigation) -> Bool {
        switch (lhs, rhs) {
        case (.search, .search):
            return true
        case (.playlist, .playlist):
            return true
        default:
            return false
        }
    }
}
