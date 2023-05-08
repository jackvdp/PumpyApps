//
//  PlaybackData.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 16/01/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import PumpyLibrary
import PumpyShared

class PlaybackData {
    
    static let shared = PlaybackData()
    private init() {}
    
    private let debouncer = Debouncer()
    private let musicContent = MusicContent()
    
    private func saveCurrentPlaybackInfo(_ playbackItem: PlaybackItem, for username: String) {
        debouncer.handle {
            FireMethods.save(object: playbackItem,
                             name: username,
                             documentName: K.FStore.currentPlayback,
                             dataFieldName: K.FStore.currentPlayback)
        }
    }
    
    
    func savePlaylistsOnline(for username: String) {
        musicContent.getPlaylists { playlists in
            let onlinePlaylists = playlists.map {
                PlaylistOnline(name: $0.title ?? "",
                               id: $0.cloudGlobalID ?? "")
            }
            FireMethods.save(object: onlinePlaylists,
                             name: username,
                             documentName: K.FStore.playlistCollection,
                             dataFieldName: K.FStore.playlistCollection)
        }
    }
    
    func saveCurrentQueueOnline(items: [Track], for username: String) {
        let tracks: [TrackOnline] = items.compactMap {
            TrackOnline(name: $0.name,
                        artist: $0.artistName,
                        id: $0.amStoreID ?? "")
        }
        FireMethods.save(object: tracks,
                         name: username,
                         documentName: K.FStore.upNext,
                         dataFieldName: K.FStore.upNext)
    }
    
    func updatePlaybackInfoOnline(for username: String, item: QueueTrack?, index: Int, playbackState: Int, playlistLabel: String) {
        var currentTrack = "Not Playing"
        var currentArtist = "– – – –"
        var id = String()
        
        if let nowPlayingItem = item {
            currentArtist = nowPlayingItem.artistName
            currentTrack = nowPlayingItem.name
            id = nowPlayingItem.amStoreID ?? ""
        }
        
        let playbackInfo = PlaybackItem(
            itemID: id,
            trackName: currentTrack,
            trackArtistName: currentArtist,
            playlistName: playlistLabel,
            playbackState: playbackState,
            versionNumber: K.versionNumber,
            queueIndex: index
        )
        
        saveCurrentPlaybackInfo(playbackInfo, for: username)
        
    }
    
}

