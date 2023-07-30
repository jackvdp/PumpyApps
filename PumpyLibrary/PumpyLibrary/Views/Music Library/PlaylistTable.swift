//
//  PlaylistTable.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 30/11/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI
public struct PlaylistTable<H:HomeProtocol,
                            P:PlaylistProtocol,
                            N:NowPlayingProtocol,
                            B:BlockedTracksProtocol,
                            T:TokenProtocol,
                            Q:QueueProtocol>: View {
    
    public init() {}
    
    @State private var playlists = [Playlist]()
    @State private var searchText = ""
    @EnvironmentObject var playlistManager: P

    public var body: some View {
        PumpyListForEach(filteredPlaylists, id: \.cloudGlobalID) { playlist in
            NavigationLink(destination: TrackTable<H,P,N,B,T,Q>(playlist: playlist)) {
                PlaylistRow(playlist: playlist)
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Playlists...")
        .navigationBarTitle("Library")
        .navigationBarTitleDisplayMode(.large)
        .accentColor(.pumpyPink)
        .pumpyBackground()
        .onAppear() {
            playlists = playlistManager.getPlaylists()
        }
    }
    
    private var filteredPlaylists: [Playlist] {
        if searchText.isEmpty {
            return playlists
        } else {
            return playlists.filter { ($0.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    
}

struct PlaylistTable_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistTable<MockHomeVM,MockPlaylistManager,MockNowPlayingManager,MockBlockedTracks,MockTokenManager,MockQueueManager>().environmentObject(MockPlaylistManager())
    }
}
