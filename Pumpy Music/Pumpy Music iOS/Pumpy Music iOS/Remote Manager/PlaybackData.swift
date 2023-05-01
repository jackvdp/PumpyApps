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
    
    private func saveCurrentPlaybackInfo(_ playbackItem: PlaybackItem, for username: String) {
        debouncer.handle {
            FireMethods.save(object: playbackItem,
                             name: username,
                             documentName: K.FStore.currentPlayback,
                             dataFieldName: K.FStore.currentPlayback)
        }
    }
    
    
    func savePlaylistsOnline(for username: String) {
        let playlists = MusicContent.getPlaylists().map {
            PlaylistOnline(name: $0.name ?? "",
                           id: $0.cloudGlobalID ?? "")
        }
        FireMethods.save(object: playlists,
                         name: username,
                         documentName: K.FStore.playlistCollection,
                         dataFieldName: K.FStore.playlistCollection)
    }

    
    func saveTracksOnline(playlist: String, for username: String) {
        let firebaseTracks = MusicContent.getOnlineTracks(chosenPlaylist: playlist)

        FireMethods.save(dict: [
            K.FStore.trackCollection : firebaseTracks,
            K.FStore.playlistName : playlist
        ],
        name: username,
        documentName: K.FStore.trackCollection)
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

