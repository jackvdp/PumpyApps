//
//  MenuView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 10/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary
import PumpyAnalytics

struct MenuView: View {
    
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var tokenManager: AuthorisationManager
    @EnvironmentObject var nowPlayingManager: NowPlayingManager
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var user: User
    @Namespace private var animation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                mainMenu
            }
            .navigationViewStyle(.stack)
            .accentColor(.pumpyPink)
            nowPlayingTrack
                .padding()
                .padding(.bottom)
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $homeVM.showPlayer) {
            playerView
        }
    }
    
    var mainMenu: some View {
        PumpyList {
            music
            scheduleAndBlocked
            settingsAndExtDisplay
            account
        }
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItem(placement: .principal) {
                PumpyView()
                    .frame(width: 120, height: 40)
            }
        }
    }
    
    var nowPlayingTrack: some View {
        MenuTrackView<
            AuthorisationManager,
            NowPlayingManager,
            BlockedTracksManager,
            PlaylistManager,
            HomeVM
        >()
    }
    
    var music: some View {
        Section {
            if settings.onlineSettings.showMusicLibrary {
                NavigationLink(destination: PlaylistTable<
                               HomeVM,
                               PlaylistManager,
                               NowPlayingManager,
                               BlockedTracksManager,
                               AuthorisationManager,
                               QueueManager
                               >(getPlaylists: MusicContent.getPlaylists)) {
                    MenuRow(title: "Music Library", imageName: "music.note.list")
                }
            }
            if settings.onlineSettings.showMusicStore {
                NavigationLink(destination: CatalogView<
                               HomeVM,
                               PlaylistManager,
                               NowPlayingManager,
                               BlockedTracksManager,
                               AuthorisationManager,
                               QueueManager>()) {
                    MenuRow(title: "Music Catalog", imageName: "music.mic")
                }
            }
        }
    }
    
    var scheduleAndBlocked: some View {
        Section {
            if settings.onlineSettings.showScheduler {
                NavigationLink(destination: ScheduleView(getPlists: MusicContent.getPlaylists)) {
                    MenuRow(title: "Playlist Schedule", imageName: "clock")
                }
            }
            if settings.onlineSettings.showBlocked {
                if let token = tokenManager.appleMusicToken, let sfID = tokenManager.appleMusicStoreFront {
                    NavigationLink(destination: BlockedTracksView(token: token, storeFront: sfID)) {
                        MenuRow(title: "Blocked Tracks", imageName: "hand.thumbsdown")
                    }
                }
                
            }
        }
    }
    
    var settingsAndExtDisplay: some View {
        Section {
            NavigationLink(destination: SettingsView()) {
                MenuRow(title: "Settings", imageName: "gear")
            }
            if settings.onlineSettings.showExternalDisplay {
                NavigationLink(destination: ExtDisplaySettingsView<PlaylistManager>()) {
                    MenuRow(title: "External Display", imageName: "tv")
                }
            }
        }
    }
    
    var account: some View {
        Section {
            NavigationLink(destination: AccountView<User,AccountManager>()) {
                MenuRow(title: "Account", imageName: "person.fill")
            }
        }
    }
    
    var playerView: some View {
        PlayerView<PlaylistManager,
                 QueueManager,
                 NowPlayingManager,
                 BlockedTracksManager,
                 HomeVM,
                 AuthorisationManager>()
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

// MARK: - Preview

struct MenuView_Previews: PreviewProvider {
    
    static let user = User(username: "1@2.com")
    static var playlist: MockPlaylistManager {
        let pm = MockPlaylistManager()
        pm.playlistLabel = "Playlist: A Bit of Lunch"
        return pm
    }
    static var homeVM: HomeVM {
        let v = HomeVM()
        v.showPlayer = false
        return v
    }
    
    static var previews: some View {
        Group {
            MenuView()
            MenuView()
                .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
        }
            .environmentObject(user)
            .environmentObject(user.musicManager)
            .environmentObject(user.musicManager.nowPlayingManager)
            .environmentObject(user.musicManager.playlistManager)
            .environmentObject(user.musicManager.blockedTracksManager)
            .environmentObject(user.settingsManager)
            .environmentObject(user.externalDisplayManager)
            .environmentObject(user.alarmData)
            .environmentObject(user.musicManager.authManager)
            .environmentObject(user.musicManager.queueManager)
            .environmentObject(homeVM)
            
    }
}
