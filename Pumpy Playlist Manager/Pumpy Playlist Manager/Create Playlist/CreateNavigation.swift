//
//  CreateNavigation.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import Foundation
import PumpyAnalytics

class CreateNavigationManager: NavigationManager {
    @Published var currentPage: CreateNavigation = .staging
}

enum CreateNavigation: NavigationSection, Equatable {
    
    case staging
    case createdPlaylist(Playlist)
    
    static func ==(lhs: CreateNavigation, rhs: CreateNavigation) -> Bool {
        switch (lhs, rhs) {
        case (.staging, .staging):
            return true
        default:
            return false
        }
    }
    
    func defaultPage() -> CreateNavigation {
        return .staging
    }
    
    func headerTitle() -> String {
        switch self {
        case .staging:
            return "Create Playlist"
        case .createdPlaylist(let playlist):
            return "\(playlist.name ?? "Recommended") Playlist"
        }
    }
    
    func previousPage() -> CreateNavigation? {
        switch self {
        case .staging:
            return nil
        case .createdPlaylist:
            return .staging
        }
    }
    
}
