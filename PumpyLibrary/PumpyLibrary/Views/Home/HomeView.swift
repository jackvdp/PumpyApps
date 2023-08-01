//
//  HomeView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 01/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct HomeView<H:HomeProtocol,
                P:PlaylistProtocol,
                N:NowPlayingProtocol,
                B:BlockedTracksProtocol,
                T:TokenProtocol,
                Q:QueueProtocol>: View {
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
                Text("Account")
            }, label: {
                Image(systemName: "person")
            })
            .foregroundColor(.white)
            .buttonStyle(.plain)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: {
                Text("Settings")
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
            HomeView<MockHomeVM,
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
        .preferredColorScheme(.dark)
        .accentColor(.pumpyPink)
    }
}
