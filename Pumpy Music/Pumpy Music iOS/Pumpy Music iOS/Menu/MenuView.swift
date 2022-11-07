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
    @State private var showNowPlaying = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                mainMenu
            }
            .accentColor(.pumpyPink)
            if showNowPlaying {
                nowPlayingTrack
            }
        }
        .onReceive(nowPlayingManager.currentTrack.publisher) { _ in
            withAnimation {
                showNowPlaying = nowPlayingManager.currentTrack != nil
            }
        }
    }
    
    var mainMenu: some View {
        List {
            music
            scheduleAndBlocked
            settingsAndExtDisplay
            account
        }
        .background(ArtworkView().background)
        .clearListBackgroundIOS16()
        .navigationBarTitle("Menu")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                dismissButton
            }
        }
    }
    
    var nowPlayingTrack: some View {
        MenuTrackView<
            AuthorisationManager,
            NowPlayingManager,
            BlockedTracksManager,
            PlaylistManager
        >().transition(.move(edge: .bottom))
    }
    
}

// MARK: - Preview

struct MenuView_Previews: PreviewProvider {
    
    static let user = User(username: "test")
    static var playlist: MockPlaylistManager {
        let pm = MockPlaylistManager()
        pm.playlistLabel = "Playlist: A Bit of Lunch"
        return pm
    }
    
    static var previews: some View {
        MenuView()
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
    }
}

// MARK: - Main Menu Components

extension MenuView {
    
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
    
    var dismissButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.body.bold())
        }
    }
}


struct ListBackgroundColor: ViewModifier {

    let color: UIColor

    func body(content: Content) -> some View {
        content
            .onAppear() {
                UITableView.appearance().backgroundColor = self.color
                //(Optional) Edit colour of cell background
                UITableViewCell.appearance().backgroundColor = self.color
            }
    }
}

extension View {
    func listBackgroundColor(color: UIColor) -> some View {
        ModifiedContent(content: self, modifier: ListBackgroundColor(color: color))
    }

}
