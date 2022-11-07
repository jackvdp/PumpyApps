//
//  HomeNavigation.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/04/2022.
//

import Foundation
import PumpyAnalytics

class LibrariesNavigationManager: NavigationManager {
    @Published var currentPage: LibrariesNavigation
    
    init() {
        currentPage = .libraries
    }
}

enum LibrariesNavigation: NavigationSection, Equatable {

    case libraries
    case playlist(PlaylistSnapshot)

    static func ==(lhs: LibrariesNavigation, rhs: LibrariesNavigation) -> Bool {
        switch (lhs, rhs) {
        case (.libraries, .libraries):
            return true
        case (let .playlist(lhsLibPlay), let .playlist(rhsLibPlay)):
            return lhsLibPlay.name == rhsLibPlay.name
        default:
            return false
        }
    }
    
    func defaultPage() -> LibrariesNavigation {
        return .libraries
    }
    
    func headerTitle() -> String {
        switch self {
        case .libraries:
            return "Libraries"
        case .playlist(let playlist):
            return playlist.name ?? "Playlist"
        }
    }
    
    func previousPage() -> LibrariesNavigation? {
        switch self {
        case .libraries:
            return nil
        case .playlist:
            return .libraries
        }
    }
    
}
