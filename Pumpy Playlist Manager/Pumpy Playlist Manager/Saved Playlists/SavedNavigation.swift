//
//  NavigationManager.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 03/03/2022.
//

import Foundation
import SwiftUI
import PumpyAnalytics

class SavedNavigationManager: NavigationManager {
    @Published var currentPage: SavedNavigation
    
    init() {
        currentPage = .saved
    }
}

enum SavedNavigation: NavigationSection, Equatable {
    
    case saved
    case playlist(PlaylistSnapshot)
    
    static func ==(lhs: SavedNavigation, rhs: SavedNavigation) -> Bool {
        switch (lhs, rhs) {
        case (.saved, .saved):
            return true
        case (let .playlist(lhsLibPlay), let .playlist(rhsLibPlay)):
            return lhsLibPlay.name == rhsLibPlay.name
        default:
            return false
        }
    }
    
    func defaultPage() -> SavedNavigation {
        return .saved
    }
    
    func headerTitle() -> String {
        switch self {
        case .saved:
            return "Saved Playlists"
        case .playlist(let playlist):
            return playlist.name ?? "Playlist"
        }
    }
    
    func previousPage() -> SavedNavigation? {
        switch self {
        case .saved:
            return nil
        case .playlist:
            return .saved
        }
    }
    
}
