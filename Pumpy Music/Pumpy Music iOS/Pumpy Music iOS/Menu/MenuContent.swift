//
//  MenuContent.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 25/11/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary
import PumpyAnalytics

struct MenuContent: View {
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var tokenManager: AuthorisationManager
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var user: User
    
    var body: some View {
        music
        scheduleAndBlocked
        settingsAndExtDisplay
        account
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
                               >(getPlaylists: MusicContent.getPlaylists), isActive: $homeVM.triggerNavigation) {
                    MenuRow(title: "Music Library", imageName: "music.note.list")
                }.tag(1)
            }
            if settings.onlineSettings.showMusicStore {
                NavigationLink(destination:
                                CatalogView<
                                   HomeVM,
                                   PlaylistManager,
                                   NowPlayingManager,
                                   BlockedTracksManager,
                                   AuthorisationManager,
                                   QueueManager
                               >()) {
                    MenuRow(title: "Music Catalog", imageName: "music.mic")
                }
            }
            if settings.onlineSettings.showMusicLab {
                NavigationLink(destination: MusicLabView<
                               NowPlayingManager,
                               BlockedTracksManager,
                               AuthorisationManager,
                               QueueManager,
                               PlaylistManager
                               >()) {
                    MenuRow(title: "Music Lab", imageName: "testtube.2")
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
            NavigationLink(destination: AccountView<AccountManager>()) {
                MenuRow(title: "Account", imageName: "person.fill")
            }
        }
    }
    
}

struct MenuContent_Previews: PreviewProvider {
    static var previews: some View {
        MenuContent()
    }
}
