//
//  NewQueueManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import PumpyLibrary
import PumpyAnalytics
import MusicKit
import PumpyShared
import MusadoraKit

class QueueManager: QueueProtocol {
    
    var username: String?
    let controller = ApplicationMusicPlayer.shared
    weak var authManager: AuthorisationManager?
    @Published var queueTracks = [PumpyLibrary.Track]()
    @Published var queueIndex = 0
    @Published var analysingEnergy = false
    
    func setUp(name: String,
               authManager: AuthorisationManager) {
        username = name
        self.authManager = authManager
    }
    
    deinit {
        print("deiniting QM")
    }
    
    // MARK: - Core Queue Methods
    
    func getQueue() {
        queueTracks = controller.queue.entries.map { $0 }
        if let currentEntry = controller.queue.currentEntry,
           let index = controller.queue.entries.firstIndex(of: currentEntry) {
            queueIndex = index
        } else {
            queueIndex = 0
        }
        
    }
    
    func removeFromQueue(id: String) {
        controller.queue.entries.removeAll(where: { $0.id == id })
        getQueue()
    }
    
    // MARK: - Track
    
    func addTrackToQueue(ids: [String], playWhen position: Position) {
        Task {
            do {
                let songs = try await MCatalog.songs(ids: ids.map { MusicItemID($0) })
                try await controller.queue.insert(songs, position: .afterCurrentEntry)
                if position == .now {
                    try await controller.skipToNextEntry()
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Queue Behaviour Methods

    func saveNewQueue(_ items: [PumpyLibrary.Track]) {
        if let username {
            PlaybackData.shared.saveCurrentQueueOnline(items: items, for: username)
        }
    }

}
