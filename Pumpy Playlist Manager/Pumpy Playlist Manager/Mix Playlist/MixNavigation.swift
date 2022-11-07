//
//  CreateNavigation.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/04/2022.
//

import Foundation
import PumpyAnalytics

class MixNavigationManager: NavigationManager {
    @Published var currentPage: MixNavigation = .staging
}

enum MixNavigation: NavigationSection, Equatable {
    
    case staging
    case playlistPreview(PlaylistSnapshot)
    case mixerSettings([PlaylistSnapshot], CustomPlaylist?)
    case sortedCustomPlaylists(oldPlaylists: [PlaylistSnapshot], tracks: CustomPlaylist, newPlaylists: [CustomPlaylist])
    
    static func ==(lhs: MixNavigation, rhs: MixNavigation) -> Bool {
        switch (lhs, rhs) {
        case (.mixerSettings, .mixerSettings):
            return true
        default:
            return false
        }
    }
    
    func defaultPage() -> MixNavigation {
        return .staging
    }
    
    func headerTitle() -> String {
        switch self {
        case .staging:
            return "Mix Playlists"
        case .playlistPreview(let playlist):
            return playlist.name ?? "Playlist"
        case .mixerSettings(let playlists, _):
            return makeHeaderFromPlaylists(playlists)
        case .sortedCustomPlaylists:
            return "New Playlists"
        }
    }
    
    private func makeHeaderFromPlaylists(_ snapshots: [PlaylistSnapshot]) -> String {
        return snapshots
            .compactMap { $0.name }
            .joined(separator: "/")
    }
    
    func previousPage() -> MixNavigation? {
        switch self {
        case .staging:
            return nil
        case .playlistPreview:
            return .staging
        case .mixerSettings:
            return .staging
        case .sortedCustomPlaylists(let oldPlaylists, let tracks, _):
            return .mixerSettings(oldPlaylists, tracks)
        }
    }
    
}
