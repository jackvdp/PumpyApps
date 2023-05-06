//
//  NewPlaylistManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import PumpyLibrary
import PumpyAnalytics
import MusicKit
import MusadoraKit

class PlaylistManager: PlaylistProtocol {
    
    private let musicPlayerController = ApplicationMusicPlayer.shared
    @Published var playlistLabel = String()
    weak var blockedTracksManager: BlockedTracksManager?
    weak var settingsManager: SettingsManager?
    weak var tokenManager: AuthorisationManager?
    weak var queueManager: QueueManager?
    let scheduleManager = ScheduleManager()
    private let playlistController = PlaylistController()
    
    init() {
        scheduleManager.playlistManager = self
    }
    
    deinit {
        print("deiniting PM")
    }
    
    func setUp(blockedTracksManager: BlockedTracksManager,
                         settingsManager: SettingsManager,
                         tokenManager: AuthorisationManager,
                         queueManager: QueueManager) {
        self.blockedTracksManager = blockedTracksManager
        self.settingsManager = settingsManager
        self.tokenManager = tokenManager
        self.queueManager = queueManager
    }
    
    // MARK: - Public Functions
    
    // MARK: Play Library Playlist
    
    
    
    /// Play playlist in AM library
    func playLibraryPlayist(_ playlist: MusicKit.Playlist, when position: Position) {
        Task {
            do {
                var request = MusicLibraryRequest<MusicKit.Playlist>()
                request.filter(matching: \.id, equalTo: playlist.id)
                let response = try await request.response()
                guard let playlist = response.items.first else { return }
                let p = try await playlist.with(.tracks)
                
                playRequestedPlaylistWithTracks(p, when: position)
            } catch {
                print(error)
            }
        }
    }
    
    /// Play playlist in AM library by name
    func playLibraryPlayist(_ name: String,
                            secondaryPlaylists: [SecondaryPlaylist],
                            when position: Position) {
        Task {
            do {
                guard let playlistWithTracks = try await getLibraryPlaylistWithTracksFromName(name) else { return }
                
                let secondaries: [(playlist: MusicKit.Playlist, ratio: Int)?] = try await secondaryPlaylists.asyncMap { playlist in
                    if let playlistWithTracks = try await getLibraryPlaylistWithTracksFromName(playlist.name) {
                        return (playlist: playlistWithTracks, ratio: playlist.ratio)
                    }
                    return nil
                }
                let secondariesWithoutNils = secondaries.compactMap { $0 }
                
                playRequestedPlaylistWithTracks(playlistWithTracks,
                                                secondaryPlaylists: secondariesWithoutNils,
                                                when: position)
                
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Play Catalog Playlist
    
    /// Play catalog playlist of AM ID
    func playCatalogPlaylist(id: String, when position: Position) {
        Task {
            do {
                let musicItemID = MusicItemID(id)
                let playlist = try await MCatalog.playlist(id: musicItemID, fetch: .tracks)
                playRequestedPlaylistWithTracks(playlist, when: position)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Private Functions
    
    /// Use this method to play a playlist after fetching tracks
    private func playRequestedPlaylistWithTracks(_ playlist: MusicKit.Playlist,
                                                 secondaryPlaylists: [(playlist: MusicKit.Playlist, ratio: Int)] = [],
                                                 when position: Position) {
        Task {
            let overallNumberOfTracks = 150
            let numberOfTracks = overallNumberOfTracks - secondaryPlaylists.reduce(0, { $0 + overallNumberOfTracks/$1.ratio })
            guard var shuffledTracks = playlist.tracks?.shuffled().prefix(numberOfTracks) else { return }
            
            // Add secondary playlists
            if !secondaryPlaylists.isEmpty {
                secondaryPlaylists.forEach { playlist, ratio in
                    if let tracks = playlist.tracks?.shuffled().prefix(overallNumberOfTracks / ratio) {
                        shuffledTracks.append(contentsOf: tracks)
                    }
                }
            }
            
            let shuffledTracksArray = shuffledTracks.shuffled()
            
            // Remove banned and explicit
            let tracksWithoutUnwanted = removeUnwantedTracks(items: shuffledTracksArray)
            
            // Add to queue
            switch position {
            case .now:
                musicPlayerController.queue = ApplicationMusicPlayer.Queue(for: tracksWithoutUnwanted)
            case .next:
                try await musicPlayerController.queue.insert(shuffledTracks, position: .afterCurrentEntry)
            }
            
            // Player settings
            musicPlayerController.state.shuffleMode = .off
            musicPlayerController.state.repeatMode = .all
            try await musicPlayerController.play()
            
            displayPlaylistInfo(playlist: playlist.name)
        }
    }
    
    /// Get a library playlist with tracks from a name
    private func getLibraryPlaylistWithTracksFromName(_ name: String) async throws -> MusicKit.Playlist?  {
        var request = MusicLibraryRequest<MusicKit.Playlist>()
        request.filter(matching: \.name, equalTo: name)
        let response = try await request.response()
        
        guard let playlist = response.items.first else { return nil }
        return try await playlist.with(.tracks)
    }
    
    private func removeUnwantedTracks(items: [MusicKit.Track]) -> [MusicKit.Track] {
        var itemsToKeep = items
        // Blocked Tracks
        if let blockedTracksManager {
            itemsToKeep.removeAll(where: { item in
                blockedTracksManager.blockedTracks.contains(where: {
                    $0.playbackID == item.amStoreID
                })
            })
        }
        // Explicit
        if settingsManager?.onlineSettings.banExplicit ?? false {
            itemsToKeep.removeAll(where: { $0.isExplicitItem })
        }
        return itemsToKeep
    }
    
    private func displayPlaylistInfo(playlist: String) {
        playlistLabel = "Playlist: \(playlist)"
    }

    // MARK: - Timer Change Playlist
    
    func changePlaylistForSchedule(alarm: Alarm) {
        if (settingsManager?.onlineSettings.overrideSchedule ?? false) == false {
            
            playLibraryPlayist(alarm.playlistLabel,
                               secondaryPlaylists: alarm.secondaryPlaylists ?? [],
                               when: .next)
            
        }
    }
    
}


extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
