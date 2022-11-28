//
//  UserView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 10/11/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary
import PumpyAnalytics

struct UserView: View {
    
    @EnvironmentObject var user: User
    @StateObject var homeVM = HomeVM()
    
    var body: some View {
        MenuView<
            HomeVM,
            PlaylistManager,
            NowPlayingManager,
            BlockedTracksManager,
            AuthorisationManager,
            QueueManager,
            User,
            MenuContent
        >(content: MenuContent())
            .environmentObject(user.musicManager)
            .environmentObject(user.musicManager.nowPlayingManager)
            .environmentObject(user.musicManager.playlistManager)
            .environmentObject(user.musicManager.blockedTracksManager)
            .environmentObject(user.settingsManager)
            .environmentObject(user.alarmData)
            .environmentObject(user.musicManager.authManager)
            .environmentObject(user.musicManager.queueManager)
            .environmentObject(homeVM)
            .environmentObject(
                ExternalDisplayManager(
                   username: user.username,
                   playlistManager: user.musicManager.playlistManager
                )
            )
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
