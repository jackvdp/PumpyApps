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
import PumpyShared

class RemoteManager: ObservableObject {
    
    var remoteListener: ListenerRegistration?
    var username: String?
    weak var alarmManager: AlarmManager?
    weak var playlistManager: PlaylistManager?
    weak var queueManager: QueueManager?
    let debouncer = Debouncer()
    
    func setUp(username: String,
               queueManager: QueueManager,
               alarmManager: AlarmManager,
               playlistManager: PlaylistManager) {
        self.username = username
        self.queueManager = queueManager
        self.alarmManager = alarmManager
        self.playlistManager = playlistManager
        recieveRemoteCommands()
    }
    
    deinit {
        print("deinit RM")
    }
    
    // MARK: - Public functions
    
    func recieveRemoteCommands() {
        if let username {
            remoteListener = FireMethods.listen(name: username,
                                                documentName: K.FStore.remoteData,
                                                dataFieldName: K.FStore.remoteData,
                                                decodeObject: RemoteInfo.self) { [weak self] remoteInfoDecoded in
                
                self?.respondToRemoteInfo(remoteInfoDecoded)
            }
        }
    }
    
    func removeListener() {
        remoteListener?.remove()
    }
    
    // MARK: - Private functions
    
    func respondToRemoteInfo(_ remoteInfo: RemoteInfo) {
        guard abs(remoteInfo.updateTime.timeIntervalSinceNow) < 5 else {
            resetRemoteInfo()
            return
        }
        
        debouncer.handle() {
            if let command = remoteInfo.remoteCommand {
                self.actOnRemoteCommand(command)
            }
            self.resetRemoteInfo()
        }
    }
    
    /// Only gets called if passes debouncer and time constraint
    private func actOnRemoteCommand(_ remoteData: RemoteEnum) {
        guard let playlistManager,
              let alarmManager,
              let queueManager,
              let username else { return }

        switch remoteData {
        case .playPause:
            MusicCoreFunctions.togglePlayPause(alarms: alarmManager.alarms, playlistManager: playlistManager)
        case .skipTrack:
            MusicCoreFunctions.skipToNextItem()
        case .previousTrack:
            MusicCoreFunctions.skipBackToBeginningOrPreviousItem()
        case .playPlaylistNow(let playlist):
            playlistManager.playLibraryPlayist(playlist, secondaryPlaylists: [], when: .now)
        case .playPlaylistNext(let playlist):
            playlistManager.playLibraryPlayist(playlist, secondaryPlaylists: [], when: .next)
        case .getLibraryPlaylists:
            PlaybackData.shared.savePlaylistsOnline(for: username)
        case .removeTrackFromQueue(let id):
            queueManager.removeFromQueue(id: id)
        case .addToQueue(let queueIDs):
            queueManager.addTrackToQueue(ids: queueIDs, playWhen: .next)
        case .activeInfo:
            ActiveInfo.save(.loggedIn, for: username)
        case .increaseEnergy:
            queueManager.increaseEnergy()
        case .decreaseEnergy:
            queueManager.decreaseEnergy()
        case .playCatalogPlaylistNow(id: let id):
            playlistManager.playCatalogPlaylist(id: id, when: .now)
        case .playCatalogPlaylistNext(id: let id):
            playlistManager.playCatalogPlaylist(id: id, when: .next)
        }
    }
    
    private func resetRemoteInfo() {
        if let username {
            FireMethods.save(object: RemoteInfo(),
                             name: username,
                             documentName: K.FStore.remoteData,
                             dataFieldName: K.FStore.remoteData)
        }
    }
    
}
