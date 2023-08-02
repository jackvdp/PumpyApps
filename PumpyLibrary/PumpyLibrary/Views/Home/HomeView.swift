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
    T:TokenProtocol,
    Q:QueueProtocol
>: View {
    
    var body: some View {
        VStack(spacing: 0) {
            CatalogView<H,P,N,B,T,Q>()
        }
        .pumpyBackground()
        .navigationTitle("Home")
        .toolbar { navBarButtons }
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
                     MockTokenManager,
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
