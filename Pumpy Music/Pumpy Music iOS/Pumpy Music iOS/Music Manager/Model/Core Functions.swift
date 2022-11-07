//
//  MusicArrays.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 01/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation
import PumpyLibrary

class MusicCoreFunctions {
    
    static let musicPlayerController = MPMusicPlayerController.applicationQueuePlayer
    
    static func togglePlayPause(alarms: [Alarm], playlistManager: PlaylistManager) {
        if musicPlayerController.playbackState == .playing {
            musicPlayerController.pause()
        } else if musicPlayerController.playbackState == .paused {
            prepareToPlayAndPlay()
        } else {
            coldStart(alarms: alarms, playlistManager: playlistManager)
        }
    }
    
    static func skipToNextItem() {
        musicPlayerController.skipToNextItem()
    }
    
    static func skipBackToBeginningOrPreviousItem() {
        if musicPlayerController.currentPlaybackTime < 5 {
            musicPlayerController.skipToPreviousItem()
        } else {
            musicPlayerController.skipToBeginning()
        }
    }
    
    static func coldStart(alarms: [Alarm], playlistManager: PlaylistManager) {
        if let playlist = alarms.getMostRecentAlarm() {
            playlistManager.playNow(playlistName: playlist.playlistLabel, secondaryPlaylists: playlist.secondaryPlaylists ?? [])
        } else {
            musicPlayerController.play()
        }
    }
    
    static func prepareToPlayAndPlay() {
        musicPlayerController.prepareToPlay { (error) in
            if let e = error {
                print(e)
            }
            self.musicPlayerController.play()
        }
    }
    
}

