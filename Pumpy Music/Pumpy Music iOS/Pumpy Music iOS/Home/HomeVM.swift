//
//  HomeVM.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI
import PumpyLibrary

class HomeVM: HomeProtocol {

    @Published var pageType: PageType = .artwork
    @Published var showMenu = false
    let alarmData: AlarmManager
    let playlistManager: PlaylistManager
    
    init(alarmData: AlarmManager, playlistManager: PlaylistManager) {
        self.alarmData = alarmData
        self.playlistManager = playlistManager
    }
    
    func playPause() {
        MusicCoreFunctions.togglePlayPause(alarms: alarmData.alarms,
                                           playlistManager: playlistManager)
    }
    
    func coldStart() {
        MusicCoreFunctions.coldStart(alarms: alarmData.alarms,
                                     playlistManager: playlistManager)
    }
    
    func skipToNextItem() {
        MusicCoreFunctions.skipToNextItem()
    }
    
}
