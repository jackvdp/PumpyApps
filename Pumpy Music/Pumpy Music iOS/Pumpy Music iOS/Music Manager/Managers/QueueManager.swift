//
//  NewQueueManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import PumpyLibrary
import PumpyAnalytics
import MusicKit
import PumpyShared

class QueueManager: QueueProtocol {
    
    var username: String
    let controller: MPMusicPlayerApplicationController
    let recieveDebouncer = Debouncer()
    let respondDebouncer = Debouncer()
    weak var authManager: AuthorisationManager?
    @Published var queueTracks = [ConstructedTrack]()
    @Published var queueIndex = 0
    @Published var analysingEnergy = false
    
    init(name: String,
         authManager: AuthorisationManager,
         controller: MPMusicPlayerApplicationController = MPMusicPlayerController.applicationQueuePlayer) {
        username = name
        self.authManager = authManager
        self.controller = controller
    }
    
    deinit {
        print("deiniting QM")
    }
    
    // MARK: - Core Queue Methods
    
    func addPlaylistToQueue(queueDescriptor: MPMusicPlayerQueueDescriptor) {
        conductQueuePerform { queue in
            var oldQueue = queue.items
            let currentIndex = self.controller.indexOfNowPlayingItem
            oldQueue.remove(at: currentIndex)
            for item in oldQueue {
                queue.remove(item)
            }
        } completion: { queue, _ in
            self.controller.prepend(queueDescriptor)
        }
    }
    
    func getUpNext() {
        conductQueuePerform { _ in
            return
        } completion: { queue, error in
            guard error == nil else { return }
            self.queueTracks = queue.items.map {
                ConstructedTrack(title: $0.title,
                                 artist: $0.artist,
                                 artworkURL: $0.artworkURL,
                                 playbackStoreID: $0.playbackStoreID,
                                 isExplicitItem: $0.isExplicitItem)
            }
            self.getIndex()
        }
    }
    
    func removeFromQueue(id: String) {
        conductQueuePerform { queue in
            let items = queue.items.filter { $0.playbackStoreID == id }
            for item in items {
                queue.remove(item)
            }
        } completion: { queue, _ in
            self.queueTracks = queue.items.map {
                ConstructedTrack(title: $0.title,
                                 artist: $0.artist,
                                 artworkURL: $0.artworkURL,
                                 playbackStoreID: $0.playbackStoreID,
                                 isExplicitItem: $0.isExplicitItem)
            }
            self.getIndex()
        }
        
    }
    
    // MARK: - Track
    
    func addTrackToQueue(ids: [String]) {
        recieveDebouncer.handle() {
            let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: ids)
            self.controller.prepend(descriptor)
        }
    }
    
    func playTrackNow(id: String) {
        recieveDebouncer.handle() {
            let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [id])
            if !(self.queueTracks.isEmpty) {
                self.controller.prepend(descriptor)
                self.controller.skipToNextItem()
                if self.controller.playbackState != .playing {
                    self.controller.play()
                }
            } else {
                self.controller.setQueue(with: descriptor)
                self.controller.play()
            }
        }
    }
    
    // MARK: - Queue Behaviour Methods
    
    func conductQueuePerform(queueTransaction: @escaping (MPMusicPlayerControllerMutableQueue)->(),
                                     completion: @escaping (MPMusicPlayerControllerQueue, Error?)->()) {
        recieveDebouncer.handle() {
            self.controller.perform(queueTransaction: queueTransaction, completionHandler: completion)
        }
        
    }
    
    func saveNewQueue(_ items: [MPMediaItem]) {
        respondDebouncer.handle() {
            PlaybackData.saveCurrentQueueOnline(items: items, for: self.username)
        }
    }
    
    func getIndex() {
        let index = controller.indexOfNowPlayingItem
        if index <= queueTracks.count {
            queueIndex = index
        }
    }

}
