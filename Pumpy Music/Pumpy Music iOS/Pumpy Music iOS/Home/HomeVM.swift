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
    @Published var showPlayer = true
    @Published var triggerNavigation: Bool = false
    
    func playPause(alarmData: AlarmManager, playlistManager: any PlaylistProtocol) {
        MusicCoreFunctions.togglePlayPause(alarms: alarmData.alarms,
                                           playlistManager: playlistManager as! PlaylistManager)
    }
    
    func coldStart(alarmData: AlarmManager, playlistManager: any PlaylistProtocol) {
        MusicCoreFunctions.coldStart(alarms: alarmData.alarms,
                                     playlistManager: playlistManager as! PlaylistManager)
    }
    
    func skipToNextItem() {
        MusicCoreFunctions.skipToNextItem()
    }
    
    func skipBack() {
        MusicCoreFunctions.skipBackToBeginningOrPreviousItem()
    }
}
