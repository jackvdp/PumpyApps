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
    
    @Published var blockedTracks = [BlockedTrack]() {
        didSet {
            saveBlockedTracks(blockedTracks: blockedTracks)
        }
    }
    let queueManager: QueueManager
    var remoteListener: FirebaseListener?
    let username: String
    
    init(username: String, queueManager: QueueManager) {
        self.username = username
        self.queueManager = queueManager
        listenForBlockedTracks()
    }
    
    deinit {
        print("deiniting")
        DeinitCounter.count += 1
    }
    
    func listenForBlockedTracks() {
        remoteListener = FireMethods.listen(db: FirebaseStore.shared.db,
                                            name: username,
                                            documentName: K.FStore.blockedTracks,
                                            dataFieldName: K.FStore.blockedTracks,
                                            decodeObject: [BlockedTrack].self) { blocked in
            self.blockedTracks = blocked
        }
    }
    
    func saveBlockedTracks(blockedTracks: [BlockedTrack]) {
        FireMethods.save(object: blockedTracks,
                         name: username,
                         documentName: K.FStore.blockedTracks,
                         dataFieldName: K.FStore.blockedTracks)
    }
    
    func unblockTrackOrAskToBlock(track: BlockedTrack) -> Bool {
        if blockedTracks.contains(where: { $0.playbackID == track.playbackID }) {
            removeTrack(id: track.playbackID)
        } else {
            return true
        }
        return false
    }
    
    func addTrackToBlockedList(_ track: BlockedTrack) {
        blockedTracks.append(track)
        queueManager.removeFromQueue(id: track.playbackID)
    }
    
    func removeTrack(id: String) {
        blockedTracks.removeAll(where: { $0.playbackID == id })
    }
    
    func removeListener() {
        remoteListener?.remove()
    }
    
}
