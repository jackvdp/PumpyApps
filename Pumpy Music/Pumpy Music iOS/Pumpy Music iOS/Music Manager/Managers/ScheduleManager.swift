//
//  ScheduleManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 29/10/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import PumpyLibrary

class ScheduleManager: NSObject {
    
    private var timer: Timer?
    private let runLoop = RunLoop.current
    weak var playlistManager: PlaylistManager?
    
    override init() {
        super.init()
        setUpPlaylistChangeTimer()
        addDefaultsObservers()
    }
    
    deinit {
        timer?.invalidate()
        removeObservers()
    }
    
    // MARK: - Playlist Monitor Timer
    
    private func setUpPlaylistChangeTimer() {
        timer?.invalidate()
        let nextAlarm = AlarmManager.loadAlarms().getNextAlarm()
        let dateToFireTimer = nextAlarm.date()
        guard let dateToFireTimer = dateToFireTimer else { return }
        
        timer = Timer(fire: dateToFireTimer, interval: 0, repeats: false) { [weak self] _ in
            self?.timer?.invalidate()
            guard let nextAlarm,
                  let self,
                  let playlistManager = self.playlistManager else { return }
            
            playlistManager.changePlaylistForSchedule(alarm: nextAlarm)
            self.setUpPlaylistChangeTimer()
        }
        
        guard let timer else { return }
        runLoop.add(timer, forMode: .common)
    }
    
}

// MARK: - Observe for alarm changes

extension ScheduleManager {
    
    private func addDefaultsObservers() {
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: K.alarmsKey,
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == K.alarmsKey {
            setUpPlaylistChangeTimer()
        }
    }
    
    func removeObservers() {
        UserDefaults.standard.removeObserver(self, forKeyPath: K.alarmsKey)
        timer?.invalidate()
    }
    
}
