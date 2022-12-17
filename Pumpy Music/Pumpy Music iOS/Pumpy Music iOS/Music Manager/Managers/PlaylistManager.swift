//
//  NewPlaylistManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import PumpyLibrary
import MediaPlayer
import PumpyAnalytics

class PlaylistManager: PlaylistProtocol {
    
    private let musicPlayerController = MPMusicPlayerApplicationController.applicationQueuePlayer
    @Published var playlistLabel = String()
    @Published var playlistURL = String()
    weak var blockedTracksManager: BlockedTracksManager?
    weak var settingsManager: SettingsManager?
    weak var tokenManager: AuthorisationManager?
    weak var queueManager: QueueManager?
    let scheduleManager = ScheduleManager()
    
    init() {
        scheduleManager.playlistManager = self
    }
    
    deinit {
        print("deiniting PM")
    }
    
    func setUpConnection(blockedTracksManager: BlockedTracksManager,
                         settingsManager: SettingsManager,
                         tokenManager: AuthorisationManager,
                         queueManager: QueueManager) {
        self.blockedTracksManager = blockedTracksManager
        self.settingsManager = settingsManager
        self.tokenManager = tokenManager
        self.queueManager = queueManager
    }
    
    // MARK: - Public Functions
    
    func playNow(playlist: PumpyLibrary.Playlist, secondaryPlaylists: [SecondaryPlaylist] = []) {
        if let mpPlaylist = playlist as? MPMediaPlaylist, let name = mpPlaylist.name {
            playNow(playlistName: name, secondaryPlaylists: secondaryPlaylists)
        } else {
            playNow(catalogPlaylist: playlist)
        }
    }
    
    func playPlaylist(playlist: PumpyLibrary.Playlist, from index: Int) {
        let tracks = playlist.tracks[index...playlist.tracks.count - 1]
        let storeIDs = tracks.map { $0.playbackStoreID }
        let queue = MPMusicPlayerStoreQueueDescriptor(storeIDs: storeIDs)
        playQueueNow(name: playlist.name ?? "", queue: queue)
    }
    
    func playNext(playlist: PumpyLibrary.Playlist, secondaryPlaylists: [SecondaryPlaylist] = []) {
        if let mpPlaylist = playlist as? MPMediaPlaylist, let name = mpPlaylist.name {
            playNext(playlistName: name, secondaryPlaylists: secondaryPlaylists)
        } else {
            playNext(catalogPlaylist: playlist)
        }
    }
    
    // MARK: - Play From Name
    
    func playNow(playlistName: String, secondaryPlaylists: [SecondaryPlaylist] = []) {
        let queue = getQueueFromPlaylists(playlist: playlistName,
                                          secondaryPlaylists: secondaryPlaylists)
        playQueueNow(name: playlistName, queue: queue)
    }
    
    func playNext(playlistName: String, secondaryPlaylists: [SecondaryPlaylist] = []) {
        guard musicPlayerController.playbackState == .playing else {
            playNow(playlistName: playlistName, secondaryPlaylists: secondaryPlaylists)
            return
        }
        
        let queueDescriptor = getQueueFromPlaylists(playlist: playlistName,
                                                    secondaryPlaylists: secondaryPlaylists)
        playQueueNext(name: playlistName, queue: queueDescriptor)
    }
    
    // MARK: - Play From Items
    
    private func playNow(catalogPlaylist: PumpyLibrary.Playlist) {
        let queue = getQueueFromCatalogPlaylist(catalogPlaylist: catalogPlaylist)
        playQueueNow(name: catalogPlaylist.name ?? "", queue: queue)
    }
    
    private func playNext(catalogPlaylist: PumpyLibrary.Playlist) {
        guard musicPlayerController.playbackState == .playing else {
            playNow(catalogPlaylist: catalogPlaylist)
            return
        }
        
        let queue = getQueueFromCatalogPlaylist(catalogPlaylist: catalogPlaylist)
        playQueueNext(name: catalogPlaylist.name ?? "", queue: queue)
    }
    
    // MARK: - Play Queue
    
    private func playQueueNow(name: String, queue: MPMusicPlayerQueueDescriptor) {
        musicPlayerController.setQueue(with: queue)
        musicPlayerController.shuffleMode = .off
        musicPlayerController.repeatMode = .all
        MusicCoreFunctions.prepareToPlayAndPlay()
        displayPlaylistInfo(playlist: name)
    }
    
    private func playQueueNext(name: String, queue: MPMusicPlayerQueueDescriptor) {
        queueManager?.addPlaylistToQueue(queueDescriptor: queue)
        displayPlaylistInfo(playlist: name)
    }
    
    // MARK: - Get items from playlist Name
    
    private func getQueueFromPlaylists(playlist: String,
                                       secondaryPlaylists: [SecondaryPlaylist]) -> MPMusicPlayerMediaItemQueueDescriptor  {
        let totalNumberOfTracks = 150
        let secondaryItems: [MPMediaItem] = secondaryPlaylists.flatMap {
            getItemsFromPlaylist(playlist: $0.name, number: totalNumberOfTracks / $0.ratio)
        }
        let primaryItems = getItemsFromPlaylist(playlist: playlist, number: totalNumberOfTracks - secondaryItems.count)
        let itemsToAdd = (primaryItems + secondaryItems).shuffled()
        
        let collection = MPMediaItemCollection(items: itemsToAdd)
        return MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
    }
    
    private func getItemsFromPlaylist(playlist: String, number: Int) -> [MPMediaItem] {
        let query = MPMediaQuery.playlists()
        let filter = MPMediaPropertyPredicate(value: playlist,
                                              forProperty: MPMediaPlaylistPropertyName,
                                              comparisonType: .equalTo)
        query.addFilterPredicate(filter)
        guard let items = query.items else {
            return []
        }
        
        return Array(removeUnwantedMPMediaItems(items: items).shuffled().prefix(number))
    }
    
    // MARK: - Get items from catalog playlist
    
    private func getQueueFromCatalogPlaylist(catalogPlaylist: PumpyLibrary.Playlist) -> MPMusicPlayerStoreQueueDescriptor {
        let wantedTracks = removeUnwantedTracks(items: catalogPlaylist.tracks)
        let storeIDs = wantedTracks.compactMap { $0.playbackStoreID }
        let shuffledAndCutIDs = Array(storeIDs.shuffled().prefix(150))
        return MPMusicPlayerStoreQueueDescriptor(storeIDs: shuffledAndCutIDs)
    }
    
    // MARK: - Remove items
    
    private func removeUnwantedMPMediaItems(items: [MPMediaItem]) -> [MPMediaItem] {
         return removeUnwantedTracks(items: items) as! [MPMediaItem]
    }
    
    private func removeUnwantedTracks(items: [PumpyLibrary.Track]) -> [PumpyLibrary.Track] {
        var itemsToKeep = items
        // Blocked Tracks
        if let blockedTracksManager {
            itemsToKeep.removeAll(where: { item in
                blockedTracksManager.blockedTracks.contains(where: {
                    $0.playbackID == item.playbackStoreID
                })
            })
        }
        // Explicit
        if settingsManager?.onlineSettings.banExplicit ?? false {
            itemsToKeep.removeAll(where: { $0.isExplicitItem })
        }
        return itemsToKeep
    }
    
    // MARK: - Set UI elements
    
    private func displayPlaylistInfo(playlist: String) {
        playlistLabel = "Playlist: \(playlist)"
        getPlaylistURL(playlist)
    }
    
    private func getPlaylistURL(_ playlist: String) {
        if let token = tokenManager?.appleMusicToken, let store = tokenManager?.appleMusicStoreFront {
            let amAPI = AppleMusicAPI(token: token, storeFront: store)
            amAPI.getPlaylistURL(playlist: playlist) { urlString in
                DispatchQueue.main.async { [weak self] in
                    self?.playlistURL = urlString
                }
            }
        }
    }

    // MARK: - Timer Change Playlist
    
    func changePlaylistForSchedule(alarm: Alarm) {
        if (settingsManager?.onlineSettings.overrideSchedule ?? false) == false {
            playNext(playlistName: alarm.playlistLabel,
                     secondaryPlaylists: alarm.secondaryPlaylists ?? [])
        }
    }
    
}
