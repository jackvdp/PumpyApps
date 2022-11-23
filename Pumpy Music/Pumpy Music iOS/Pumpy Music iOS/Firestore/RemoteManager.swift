//
//  RemoteDataManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 27/01/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation
import Firebase
import PumpyLibrary
import UIKit
import PumpyShared

class RemoteManager: ObservableObject {
    
    var remoteListener: ListenerRegistration?
    let username: String
    weak var musicManager: MusicManager?
    weak var alarmManager: AlarmManager?
    let debouncer = Debouncer()
    
    init(username: String, musicManager: MusicManager?, alarmManager: AlarmManager?) {
        self.username = username
        self.musicManager = musicManager
        self.alarmManager = alarmManager
        recieveRemoteCommands()
    }
    
    deinit {
        DeinitCounter.count += 1
    }
    
    func recieveRemoteCommands() {
        remoteListener = FireMethods.listen(name: username,
                                            documentName: K.FStore.remoteData,
                                            dataFieldName: K.FStore.remoteData,
                                            decodeObject: RemoteInfo.self) { remoteInfoDecoded in
            
            self.respondToRemoteInfo(remoteInfoDecoded)
        }
    }
    
    func removeListener() {
        remoteListener?.remove()
    }
    
    func respondToRemoteInfo(_ remoteInfo: RemoteInfo) {
        guard abs(remoteInfo.updateTime.timeIntervalSinceNow) < 5 else {
            resetRemoteInfo()
            return
        }
        
        debouncer.handler = {
            if let command = remoteInfo.remoteCommand {
                self.actOnRemoteCommand(command)
            }
            self.resetRemoteInfo()
        }
    }
    
    private func actOnRemoteCommand(_ remoteData: RemoteEnum) {
        guard let musicManager = musicManager, let alarmManager = alarmManager else { return }

        switch remoteData {
        case .playPause:
            MusicCoreFunctions.togglePlayPause(alarms: alarmManager.alarms, playlistManager: musicManager.playlistManager)
        case .skipTrack:
            MusicCoreFunctions.skipToNextItem()
        case .previousTrack:
            MusicCoreFunctions.skipBackToBeginningOrPreviousItem()
        case .playPlaylistNow(let playlist):
            musicManager.playlistManager.playNow(playlistName: playlist)
        case .playPlaylistNext(let playlist):
            musicManager.playlistManager.playNext(playlistName: playlist)
        case .getLibraryPlaylists:
            PlaybackData.savePlaylistsOnline(for: username)
        case .getTracksFromPlaylist(let playlist):
            PlaybackData.saveTracksOnline(playlist: playlist, for: username)
        case .removeTrackFromQueue(let id):
            musicManager.queueManager.removeFromQueue(id: id)
        case .addToQueue(let queueIDs):
            musicManager.queueManager.addTrackToQueue(ids: queueIDs)
        case .activeInfo:
            ActiveInfo.save(.loggedIn, for: username)
        case .increaseEnergy:
            musicManager.queueManager.increaseEnergy()
        case .decreaseEnergy:
            musicManager.queueManager.decreaseEnergy()
        }
    }
    
    private func resetRemoteInfo() {
        FireMethods.save(object: RemoteInfo(),
                         name: username,
                         documentName: K.FStore.remoteData,
                         dataFieldName: K.FStore.remoteData)
    }
    
}
