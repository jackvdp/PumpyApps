//
//  HomeView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 01/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct HomeView<
    A:AccountManagerProtocol,
    H:HomeProtocol,
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                rows
                CatalogView<H,P,N,B,Q>()
            }
        }
        .pumpyBackground()
        .navigationTitle("Home")
        .toolbar { navBarButtons }
    }
    
    var rows: some View {
        VStack(spacing: 0) {
            Divider()
            NavigationLink(destination: ScheduleView<P>()) {
                MenuRow(title: "Playlist Schedule", imageName: "clock", showChevron: true)
            }
            Divider()
            NavigationLink(destination: BookmarkedView<N,B,P,Q>()) {
                MenuRow(title: "Bookmarked", imageName: "hand.thumbsup", showChevron: true)
            }
            Divider()
            NavigationLink(destination: BlockedTracksView<B>()) {
                MenuRow(title: "Blocked Tracks", imageName: "hand.thumbsdown", showChevron: true)
            }
            Divider()
        }
        .padding(.horizontal)
        .buttonStyle(.plain)
    }
    
    @ToolbarContentBuilder
    var navBarButtons: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink(destination: {
                AccountView<A>()
            }, label: {
                Image(systemName: "person")
            })
            .foregroundColor(.white)
            .buttonStyle(.plain)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: {
                SettingsView()
            }, label: {
                Image(systemName: "gearshape")
            })
            .foregroundColor(.white)
            .buttonStyle(.plain)
        }
    }
}

struct NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView<MockAccountManager,
                     MockHomeVM,
                     MockPlaylistManager,
                     MockNowPlayingManager,
                     MockBlockedTracks,
                     MockQueueManager>()
        }
        .environmentObject(AuthorisationManager())
        .environmentObject(MockHomeVM())
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockQueueManager())
        .environmentObject(MusicLabManager())
        .environmentObject(ToastManager())
        .environmentObject(SettingsManager())
        .environmentObject(MockAccountManager())
        .preferredColorScheme(.dark)
        .accentColor(.pumpyPink)
    }
}
