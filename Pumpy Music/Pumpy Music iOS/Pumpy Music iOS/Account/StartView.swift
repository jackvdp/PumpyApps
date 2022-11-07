//
//  StartView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary
import PumpyAnalytics

struct StartView: View {
    
    @EnvironmentObject var accountManager: AccountManager
    
    var body: some View {
        VStack {
            if let user = accountManager.user {
                UserView()
                    .environmentObject(user)
            } else {
                switch accountManager.pageState {
                case .login:
                    LoginView<AccountManager>(
                        usernamePlaceholder: "Enter your username",
                        buttonText: "Log In",
                        pageSwitchText: "Register"
                    )
                case .register:
                    LoginView<AccountManager>(
                        usernamePlaceholder: "Enter your email address",
                        buttonText: "Register",
                        pageSwitchText: "Already have an account?"
                    )
                }
            }
        }
    }
}

#if DEBUG
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(AccountManager())
    }
}
#endif

private struct UserView: View {
    
    @EnvironmentObject var user: User
    
    var body: some View {
        HomeView<PlaylistManager,
                 QueueManager,
                 NowPlayingManager,
                 BlockedTracksManager,
                 HomeVM,
                 AuthorisationManager,
                 MenuView>(
                    homeVM: HomeVM(
                        alarmData: user.alarmData,
                        playlistManager: user.musicManager.playlistManager),
                    menuView: MenuView())
                 .environmentObject(user.musicManager)
                 .environmentObject(user.musicManager.nowPlayingManager)
                 .environmentObject(user.musicManager.playlistManager)
                 .environmentObject(user.musicManager.blockedTracksManager)
                 .environmentObject(user.settingsManager)
                 .environmentObject(user.alarmData)
                 .environmentObject(user.musicManager.authManager)
                 .environmentObject(user.musicManager.queueManager)
                 .environmentObject(
                     ExternalDisplayManager(
                        username: user.username,
                        playlistManager: user.musicManager.playlistManager
                     )
                 )
    }
    
}
