//
//  GraphQL_TestApp.swift
//  GraphQL Test
//
//  Created by Jack Vanderpump on 10/02/2022.
//

import SwiftUI
import Firebase
import PumpyAnalytics

@main
struct PumpyPlaylistManager: App {
    
    @StateObject var playerManager = PlayerManager()
    @StateObject var homeManager = LibrariesManager()
    @StateObject var authroisationManager = AuthorisationManager()
    @StateObject var accountManager = AccountManager()
    @StateObject var createManager = CreateManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800,
                       minHeight: 400,
                       alignment: .center)
                .environmentObject(playerManager)
                .environmentObject(accountManager)
                .environmentObject(accountManager.savedPlaylistsController)
                .environmentObject(authroisationManager)
                .environmentObject(homeManager)
                .environmentObject(createManager)
                .onAppear {
                    authroisationManager.fetchTokens()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .onChange(of: authroisationManager.appleMusicToken) { _ in
            homeManager.getPlaylistsfromMusicLibrary(authManager: authroisationManager)
        }
        .onChange(of: authroisationManager.spotifyToken) { _ in
            print("get Spotify playlists")
        }
        
    }
    
}
