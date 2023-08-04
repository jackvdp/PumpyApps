//
//  BlockedTracks.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 28/06/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import SwiftUI
import PumpyLibrary

class BlockedTracksManager: BlockedTracksProtocol {
    
    @Published var blockedTracks = [CodableTrack]() {
        didSet {
            saveBlockedTracks(blockedTracks: blockedTracks)
        }
    }
    weak var queueManager: QueueManager?
    var remoteListener: FirebaseListener?
    var username: Username?
    
    func setUp(username: Username, queueManager: QueueManager) {
        self.username = username
        self.queueManager = queueManager
        listenForBlockedTracks()
    }
    
    deinit {
        print("deiniting BTM")
    }
    
    func listenForBlockedTracks() {
        if let username {
            remoteListener = FireMethods.listen(name: username,
                                                documentName: K.FStore.blockedTracks,
                                                dataFieldName: K.FStore.blockedTracks,
                                                decodeObject: [CodableTrack].self) { [weak self] blocked in
                self?.blockedTracks = blocked
            }
        }
    }
    
    func saveBlockedTracks(blockedTracks: [CodableTrack]) {
        if let username {
            FireMethods.save(object: blockedTracks,
                             name: username,
                             documentName: K.FStore.blockedTracks,
                             dataFieldName: K.FStore.blockedTracks)
        }
    }
    
    func unblockTrackOrAskToBlock(track: CodableTrack?) -> Bool {
        guard let track else { return false }
        if blockedTracks.contains(where: { $0.playbackID == track.playbackID }) {
            removeTrack(id: track.playbackID)
        } else {
            return true
        }
        return false
    }
    
    func addTrackToBlockedList(_ track: CodableTrack) {
        blockedTracks.append(track)
        queueManager?.removeFromQueue(id: track.playbackID)
    }
    
    func removeTrack(id: String) {
        blockedTracks.removeAll(where: { $0.playbackID == id })
    }
    
    func removeListener() {
        remoteListener?.remove()
    }
    
}
