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
    @StateObject var musicManager = MusicManager()
    @StateObject var authManager = AuthorisationManager()
    @StateObject var nowPlayingManager = NowPlayingManager()
    @StateObject var playlistManager = PlaylistManager()

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
            .environmentObject(user.externalDisplayManager)
            .onChange(of: musicManager.musicPlayerManagerDidUpdate) { _ in
                queueManager.getIndex()
                nowPlayingManager.updateTrackData()
                nowPlayingManager.updateTrackOnline(for: user.username,
                                                    playlist: playlistManager.playlistLabel)
            }
            .onChange(of: musicManager.queueDidUpdate) { _ in
                queueManager.getUpNext()
            }
            .onAppear() {
                authManager.fetchTokens()
            }
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
