//
//  MenuView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 10/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyAnalytics
import PumpyShared

public struct MenuView<H:HomeProtocol,
                       P:PlaylistProtocol,
                       N:NowPlayingProtocol,
                       B:BlockedTracksProtocol,
                       T:TokenProtocol,
                       Q:QueueProtocol,
                       U:UserProtocol,
                       Content:View>: View {
    
    public init(settings: SettingsManager, blockedTracksManager: B, nowPlayingManager: N, playlistManager: P, homeVM: H, user: U, alarmManager: AlarmManager, authManager: AuthorisationManager, queueManager: Q, labManager: MusicLabManager, content: @escaping () -> Content) {
        self.settings = settings
        self.blockedTracksManager = blockedTracksManager
        self.nowPlayingManager = nowPlayingManager
        self.playlistManager = playlistManager
        self.homeVM = homeVM
        self.user = user
        self.alarmManager = alarmManager
        self.authManager = authManager
        self.queueManager = queueManager
        self.labManager = labManager
        self.content = content
    }
    
    @ObservedObject var settings: SettingsManager
    @ObservedObject var blockedTracksManager: B
    @ObservedObject var nowPlayingManager: N
    @ObservedObject var playlistManager: P
    @ObservedObject var homeVM: H
    @ObservedObject var user: U
    @ObservedObject var alarmManager: AlarmManager
    @ObservedObject var authManager: AuthorisationManager
    @ObservedObject var queueManager: Q
    @ObservedObject var labManager: MusicLabManager
    let content: () -> Content
    @State private var showPlayer = true
    
    public var body: some View {
        VStack(spacing: 0) {
            mainMenu
            nowPlayingTrack
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $showPlayer) {
            playerView
        }
        .onChange(of: homeVM.showPlayer) { newValue in
            showPlayer = newValue
        }
    }
    
    // MARK: Components
    
    var mainMenu: some View {
        GeometryReader { geo in
            NavigationView {
                PumpyList {
                    content()
                }
                .listStyle(.insetGrouped)
                .toolbar { logo }
                .pumpyBackground()
                .searchToolbar(destination: SearchView<H,P,N,B,T,Q>())
            }
            .accentColor(.pumpyPink)
            .pumpyNavigation(isLandscape: isLandscape(geo: geo))
            .onAppear() {
                activatePage(geo)
            }
            .onChange(of: geo.size.width) { _ in
                activatePage(geo)
            }
            .environmentObject(nowPlayingManager)
            .environmentObject(playlistManager)
            .environmentObject(blockedTracksManager)
            .environmentObject(settings)
            .environmentObject(alarmManager)
            .environmentObject(authManager)
            .environmentObject(queueManager)
            .environmentObject(homeVM)
            .environmentObject(user)
            .environmentObject(labManager)
        }
    }
    
    @ViewBuilder
    var nowPlayingTrack: some View {
        Divider()
        MenuTrackView<T,N,B,P,H>()
            .environmentObject(nowPlayingManager)
            .environmentObject(playlistManager)
            .environmentObject(blockedTracksManager)
            .environmentObject(settings)
            .environmentObject(alarmManager)
            .environmentObject(authManager)
            .environmentObject(queueManager)
            .environmentObject(homeVM)
            .environmentObject(labManager)
    }
    
    var playerView: some View {
        PlayerView<P,Q,N,B,H,T>()
                 .environmentObject(nowPlayingManager)
                 .environmentObject(playlistManager)
                 .environmentObject(blockedTracksManager)
                 .environmentObject(settings)
                 .environmentObject(alarmManager)
                 .environmentObject(authManager)
                 .environmentObject(queueManager)
                 .environmentObject(homeVM)
                 .environmentObject(labManager)
    }

    var logo: ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            PumpyView()
                .frame(width: 120, height: 40)
        }
    }
    
    // MARK: Functions
    
    func isLandscape(geo: GeometryProxy) -> Bool {
        geo.size.width > geo.size.height
    }
    
    func activatePage(_ geo: GeometryProxy) {
        if isLandscape(geo: geo) {
            homeVM.triggerNavigation = true
        }
    }
}

// MARK: - Preview

#if DEBUG
struct MenuView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            menuView
            menuView
                .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
        }
    }

    static let user = MockUser()
    static var playlist: MockPlaylistManager {
        let pm = MockPlaylistManager()
        pm.playlistLabel = "Playlist: A Bit of Lunch"
        return pm
    }
    static var homeVM: MockHomeVM {
        let v = MockHomeVM()
        v.showPlayer = false
        return v
    }

    typealias MenuV = MenuView<MockHomeVM,
                               MockPlaylistManager,
                               MockNowPlayingManager,
                               MockBlockedTracks,
                               MockTokenManager,
                               MockQueueManager,
                               MockUser,
                               EmptyView>
    
    static var menuView = MenuV(settings: SettingsManager(),
                                blockedTracksManager: MockBlockedTracks(),
                                nowPlayingManager: MockNowPlayingManager(),
                                playlistManager: playlist,
                                homeVM: homeVM,
                                user: user,
                                alarmManager: AlarmManager(),
                                authManager: AuthorisationManager(),
                                queueManager: MockQueueManager(),
                                labManager: MusicLabManager(),
                                content: {EmptyView()})

}
#endif
