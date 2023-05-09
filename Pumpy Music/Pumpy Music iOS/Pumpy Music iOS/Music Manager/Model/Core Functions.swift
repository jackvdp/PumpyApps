//
//  MusicArrays.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 01/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import Foundation
import MusicKit
import PumpyLibrary

class MusicCoreFunctions {
    
    static let musicPlayerController = ApplicationMusicPlayer.shared
    
    static func togglePlayPause(alarms: [Alarm], playlistManager: PlaylistManager) {
        if musicPlayerController.state.playbackStatus == .playing {
            musicPlayerController.pause()
        } else if musicPlayerController.state.playbackStatus == .paused {
            prepareToPlayAndPlay()
        } else {
            coldStart(alarms: alarms, playlistManager: playlistManager)
        }
    }
    
    static func skipToNextItem() {
        Task {
            do {
                try await musicPlayerController.skipToNextEntry()
            } catch {
                print(error)
            }
        }
    }
    
    static func skipBackToBeginningOrPreviousItem() {
        Task {
            do {
                if musicPlayerController.playbackTime < 5 {
                    try await musicPlayerController.skipToPreviousEntry()
                } else {
                    musicPlayerController.restartCurrentEntry()
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func coldStart(alarms: [Alarm], playlistManager: PlaylistManager) {
        if let playlist = alarms.getMostRecentAlarm() {
            playlistManager.playLibraryPlayist(playlist.playlistLabel,
                                               secondaryPlaylists: playlist.secondaryPlaylists ?? [],
                                               when: .now)
        } else {
            Task {
                try await musicPlayerController.play()
            }
        }
    }
    
    static func prepareToPlayAndPlay() {
        Task {
            do {
                try await musicPlayerController.prepareToPlay()
                try await musicPlayerController.play()
            } catch {
                print(error)
            }
        }
    }
    
}

