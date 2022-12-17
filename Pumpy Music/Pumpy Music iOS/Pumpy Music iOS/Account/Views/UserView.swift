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

    var body: some View {
        viewAndDependencies
            .onAppear() {
                setUp()
                authManager.fetchTokens()
            }
    }
  
    var viewAndDependencies: some View {
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
            .environmentObject(musicManager)
            .environmentObject(nowPlayingManager)
            .environmentObject(playlistManager)
            .environmentObject(blockedTracksManager)
            .environmentObject(settingsManager)
            .environmentObject(alarmManager)
            .environmentObject(authManager)
            .environmentObject(queueManager)
            .environmentObject(homeVM)
    }
    
    func setUp() {
        musicManager.setUpConnection(nowPlayingManager: nowPlayingManager,
                                     playlistManager: playlistManager,
                                     queueManager: queueManager,
                                     blockedTracksManager: blockedTracksManager,
                                     settingsManager: settingsManager,
                                     authManager: authManager,
                                     username: user.username,
                                     remoteManager: remoteManager)
        nowPlayingManager.setUpConnection(authManager: authManager)
        playlistManager.setUpConnection(blockedTracksManager: blockedTracksManager,
                                        settingsManager: settingsManager,
                                        tokenManager: authManager,
                                        queueManager: queueManager)
        queueManager.setUpConnection(name: user.username,
                                     authManager: authManager)
        blockedTracksManager.setUpConnection(username: user.username,
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
        UserView()
    }
}
#endif
