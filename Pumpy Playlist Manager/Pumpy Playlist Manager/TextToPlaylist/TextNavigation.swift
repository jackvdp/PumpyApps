//
//  TextNavigation.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 31/10/2022.
//

import Foundation
import PumpyAnalytics

class TextNavigationManager: NavigationManager {
    @Published var currentPage: TextNavigation = .text
}

enum TextNavigation: NavigationSection, Equatable {
    
    case text
    case playlist(Playlist)
    
    func defaultPage() -> TextNavigation {
        return .text
    }
    
    func headerTitle() -> String {
        switch self {
        case .text:
            return "Text Converter"
        case .playlist:
            return "Text Playlist"
        }
    }
    
    func previousPage() -> TextNavigation? {
        switch self {
        case .text:
            return nil
        case .playlist:
            return .text
        }
    }
    
    static func == (lhs: TextNavigation, rhs: TextNavigation) -> Bool {
        switch (lhs, rhs) {
        case (.text, .text):
            return true
        case (.playlist(let playlistA), .playlist(let playlistB)):
            return playlistA.uuid == playlistB.uuid
        default:
            return false
        }
    }
    
}
