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
    
    private let musicPlayer = ApplicationMusicPlayer.shared
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
    
    // MARK: Play Any Playlist
    
    func playPlaylist(_ playlist: PumpyLibrary.Playlist, fromLibrary: Bool, when position: Position) {
        if let analyticsPlaylist = playlist as? PumpyAnalytics.Playlist {
            let amIDS = analyticsPlaylist.tracks.compactMap { $0.amStoreID }
            let shuffledIDs = amIDS.shuffled()
            queueManager?.addTracksToQueue(ids: shuffledIDs, playWhen: position)
            playlistLabel = playlist.title ?? "Playlist"
        } else if let mkPlaylist = playlist as? MusicKit.Playlist {
            if fromLibrary {
                playLibraryPlayist(mkPlaylist, when: position)
            } else {
                playCatalogPlaylist(id: mkPlaylist.id.rawValue, when: position)
            }
        } else {
            fatalError()
        }
    }
    
    // MARK: Play Library Playlist
    
    /// Play playlist in AM library
    func playLibraryPlayist(_ playlist: MusicKit.Playlist, when position: Position) {
        Task(priority: .high) {
            do {
                let playlist = try await MLibrary.playlist(id: playlist.id)
                let p = try await playlist.with(.tracks)
                await playRequestedPlaylistWithTracks(p, when: position)
            } catch {
                print(error)
            }
        }
    }
    
    /// Play playlist in AM library by name
    func playLibraryPlayist(_ name: String,
                            secondaryPlaylists: [SecondaryPlaylist],
                            when position: Position) {
        Task(priority: .high) {
            do {
                guard let playlistWithTracks = try await getLibraryPlaylistWithTracksFromName(name) else { return }
                
                let secondaries: [(playlist: MusicKit.Playlist, ratio: Int)?] = try await secondaryPlaylists.asyncMap { playlist in
                    if let playlistWithTracks = try await getLibraryPlaylistWithTracksFromName(playlist.name) {
                        return (playlist: playlistWithTracks, ratio: playlist.ratio)
                    }
                    return nil
                }
                let secondariesWithoutNils = secondaries.compactMap { $0 }
                
                await playRequestedPlaylistWithTracks(playlistWithTracks,
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
        Task(priority: .high) {
            do {
                let musicItemID = MusicItemID(id)
                let playlist = try await MCatalog.playlist(id: musicItemID, fetch: .tracks)
                await playRequestedPlaylistWithTracks(playlist, when: position)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Get Library Playlists & Tracks
    
    func getLibraryPlaylists() async -> [PumpyLibrary.Playlist] {
        do {
            let playlists = try await MLibrary.playlists()
            let playlistArray = playlists.map { $0 }
            return playlistArray
        } catch {
            print(error)
            return []
        }
    }
    
    func getLibraryPlaylistTracks(playlist: PumpyLibrary.Playlist) async -> [PumpyLibrary.Track] {
        guard let mkPlaylist = playlist as? MusicKit.Playlist else { return [] }
        do {
            let playlistWithTracks = try await mkPlaylist.with(.tracks)
            guard let tracks = playlistWithTracks.tracks else { return [] }
            return tracks.map { $0 as MusicKit.Track }.sorted { $0.artistName < $1.artistName }
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: - Private Functions
    
    /// Use this method to play a playlist after fetching tracks
    private func playRequestedPlaylistWithTracks(_ playlist: MusicKit.Playlist,
                                                 secondaryPlaylists: [(playlist: MusicKit.Playlist, ratio: Int)] = [],
                                                 when position: Position) async {
        do {
            // Pull tracks from playlists either in order from index or randomly selected
            let requestedTracks = pullTracksFromPlaylist(playlist: playlist,
                                                         secondaryPlaylists: secondaryPlaylists,
                                                         position: position)
            
            // Remove banned and explicit
            var tracksWithoutUnwanted = removeUnwantedTracks(items: requestedTracks)
            guard tracksWithoutUnwanted.isNotEmpty else { return }
            
            // Add to queue
            switch position {
            case .now, .at:
                musicPlayer.queue = ApplicationMusicPlayer.Queue(for: tracksWithoutUnwanted)
                musicPlayer.state.shuffleMode = .off
                musicPlayer.state.repeatMode = .all
                try await musicPlayer.prepareToPlay()
                try await musicPlayer.play()
            case .next:
                try await musicPlayer.queue.insert(tracksWithoutUnwanted, position: .tail)
            }

            await displayPlaylistInfo(playlist: playlist.name)
        } catch {
            print(error)
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
    
    @MainActor
    private func displayPlaylistInfo(playlist: String) {
        playlistLabel = "Playlist: \(playlist)"
    }
    
    private func pullTracksFromPlaylist(playlist: MusicKit.Playlist,
                                        secondaryPlaylists: [(playlist: MusicKit.Playlist, ratio: Int)],
                                        position: Position,
                                        overallNumberOfTracks: Int = 99) -> [MusicKit.Track] {
        switch position {
            
        case .at(let index):
            
            guard let tracks = playlist.tracks, index < tracks.count else { return [] }
            let finalIndex = index + 98 < tracks.count ? index + 98 : tracks.count - 1

            return Array(tracks[index...finalIndex])
            
        default:
            
            let numberOfTracks = overallNumberOfTracks - secondaryPlaylists.reduce(0, { $0 + overallNumberOfTracks/$1.ratio })
            guard var shuffledTracks = playlist.tracks?.shuffled().prefix(numberOfTracks) else { return [] }

            // Add secondary playlists
            secondaryPlaylists.forEach { playlist, ratio in
                if let tracks = playlist.tracks?.shuffled().prefix(overallNumberOfTracks / ratio) {
                    shuffledTracks.append(contentsOf: tracks)
                }
            }
            return shuffledTracks.shuffled()
            
        }
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
