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
    
    var username: Username?
    let controller = MPMusicPlayerController.applicationQueuePlayer
    let recieveDebouncer = Debouncer()
    let respondDebouncer = Debouncer()
    weak var authManager: AuthorisationManager?
    @Published var queueTracks = [PumpyLibrary.Track]()
    @Published var queueIndex = 0
    @Published var analysingEnergy = false
    let analyseController = AnalyseController()
    
    func setUp(name: Username,
               authManager: AuthorisationManager) {
        username = name
        self.authManager = authManager
    }
    
    deinit {
        print("deiniting QM")
    }
    
    // MARK: - Core Queue Methods
    
    func addPlaylistToQueue(queueDescriptor: MPMusicPlayerQueueDescriptor) {
        conductQueuePerform { [weak self] queue in
            var oldQueue = queue.items
            guard let currentIndex = self?.controller.indexOfNowPlayingItem else { return }
            oldQueue.remove(at: currentIndex)
            for item in oldQueue {
                queue.remove(item)
            }
        } completion: { [weak self] queue, _ in
            self?.controller.prepend(queueDescriptor)
        }
    }
    
    func getUpNext() {
        conductQueuePerform { _ in
            return
        } completion: { [weak self] queue, error in
            guard let self, error == nil else { return }
            queueTracks = queue.items
            getIndex()
        }
    }
    
    func removeFromQueue(id: String) {
        conductQueuePerform { queue in
            let items = queue.items.filter { $0.playbackStoreID == id }
            for item in items {
                queue.remove(item)
            }
        } completion: { [weak self] queue, error in
            guard let self, error == nil else { return }
            queueTracks = queue.items
            getIndex()
        }
        
    }
    
    // MARK: - Track
    
    func addTrackToQueue(ids: [String]) {
        recieveDebouncer.handle() { [weak self] in
            let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: ids)
            self?.controller.prepend(descriptor)
        }
    }
    
    func playTrackNow(id: String) {
        recieveDebouncer.handle() { [weak self] in
            guard let self else { return }
            let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [id])
            if !(queueTracks.isEmpty) {
                controller.prepend(descriptor)
                controller.skipToNextItem()
                if controller.playbackState != .playing {
                    controller.play()
                }
            } else {
                controller.setQueue(with: descriptor)
                controller.play()
            }
        }
    }
    
    // MARK: - Queue Behaviour Methods
    
    func conductQueuePerform(queueTransaction: @escaping (MPMusicPlayerControllerMutableQueue)->(),
                                     completion: @escaping (MPMusicPlayerControllerQueue, Error?)->()) {
        recieveDebouncer.handle() { [weak self] in
            self?.controller.perform(queueTransaction: queueTransaction, completionHandler: completion)
        }
        
    }
    
    func saveNewQueue(_ items: [MPMediaItem]) {
        if let username {
            respondDebouncer.handle() {
                PlaybackData.shared.saveCurrentQueueOnline(items: items, for: username)
            }
        }
    }
    
    func getIndex() {
        let index = controller.indexOfNowPlayingItem
        if index <= queueTracks.count {
            queueIndex = index
        }
    }

}
