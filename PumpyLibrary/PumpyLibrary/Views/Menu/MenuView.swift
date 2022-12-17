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
    
    public init(content: Content) {
        self.content = content
    }
    
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var tokenManager: T
    @EnvironmentObject var blockedTracksManager: B
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var homeVM: H
    @EnvironmentObject var user: U
    @EnvironmentObject var alarmManager: AlarmManager
    @EnvironmentObject var authManager: AuthorisationManager
    @EnvironmentObject var queueManager: Q
    let content: Content
    @State private var showPlayer = true
    
    public var body: some View {
        ZStack(alignment: .bottom) {
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
    
    var mainMenu: some View {
        GeometryReader { geo in
            NavigationView {
                PumpyList() {
                    content
                }
                .listStyle(.insetGrouped)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        PumpyView()
                            .frame(width: 120, height: 40)
                    }
                }
            }
            .accentColor(.pumpyPink)
            .pumpyNavigation(isLandscape: isLandscape(geo: geo))
            .onAppear() {
                activatePage(geo)
            }
            .onChange(of: geo.size.width) { _ in
                activatePage(geo)
            }
        }
    }
    
    var nowPlayingTrack: some View {
        MenuTrackView<T,N,B,P,H>()
            .padding()
            .padding(.bottom)
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
    }
    
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

struct MenuView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            MenuV(content: EmptyView())
            MenuV(content: EmptyView())
                .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
        }
        .environmentObject(user)
        .environmentObject(MockMusicMananger())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(SettingsManager())
        .environmentObject(AlarmManager())
        .environmentObject(MockTokenManager())
        .environmentObject(MockQueueManager())
        .environmentObject(MockHomeVM())
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
    
}

