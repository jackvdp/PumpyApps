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
    
    @ObservedObject var user: User
    @StateObject private var homeVM = HomeVM()
    @StateObject private var musicManager = MusicManager()
    @StateObject private var authManager = AuthorisationManager()
    @StateObject private var nowPlayingManager = NowPlayingManager()
    @StateObject private var playlistManager = PlaylistManager()
    @StateObject private var queueManager = QueueManager()
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var blockedTracksManager = BlockedTracksManager()
    @StateObject private var alarmManager = AlarmManager()
    @StateObject private var remoteManager = RemoteManager()
    @StateObject private var labManager = MusicLabManager()

    var body: some View {
        PumpyTabView<
            HomeVM,
            PlaylistManager,
            NowPlayingManager,
            BlockedTracksManager,
            AuthorisationManager,
            QueueManager,
            User
        >()
            .environmentObject(settingsManager)
            .environmentObject(blockedTracksManager)
            .environmentObject(nowPlayingManager)
            .environmentObject(homeVM)
            .environmentObject(user)
            .environmentObject(alarmManager)
            .environmentObject(authManager)
            .environmentObject(queueManager)
            .environmentObject(playlistManager)
            .environmentObject(remoteManager)
            .environmentObject(labManager)
            .musicToasts()
            .onAppear() {
                setUp()
                authManager.fetchTokens()
            }
    }

    func setUp() {
        musicManager.setUp(nowPlayingManager: nowPlayingManager,
                           playlistManager: playlistManager,
                           queueManager: queueManager,
                           blockedTracksManager: blockedTracksManager,
                           settingsManager: settingsManager,
                           authManager: authManager,
                           username: user.username,
                           remoteManager: remoteManager)
        nowPlayingManager.setUp(authManager: authManager)
        playlistManager.setUp(blockedTracksManager: blockedTracksManager,
                              settingsManager: settingsManager,
                              tokenManager: authManager,
                              queueManager: queueManager)
        queueManager.setUp(name: user.username,
                           authManager: authManager)
        blockedTracksManager.setUp(username: user.username,
                                   queueManager: queueManager)
        settingsManager.setUp(username: user.username)
        alarmManager.setUp(username: user.username)
        remoteManager.setUp(username: user.username,
                            queueManager: queueManager,
                            alarmManager: alarmManager,
                            playlistManager: playlistManager)
        (UIApplication.shared.delegate as! AppDelegate).remoteDataManager = remoteManager
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.user = user
    }
    
}

#if DEBUG
struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User(username: .account("Test")))
    }
}
#endif
