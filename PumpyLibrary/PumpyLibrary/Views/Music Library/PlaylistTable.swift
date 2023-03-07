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
    
    public init(getPlaylists: @escaping () -> [Playlist]) {
        self.getPlaylists = getPlaylists
    }
    
    @State private var playlists = [Playlist]()
    @State private var searchText = ""
    @State private var tableView: UITableView?
    var getPlaylists: ()->[Playlist]

    public var body: some View {
        PumpyList {
            ForEach(filteredPlaylists.indices, id: \.self) { i in
                NavigationLink(destination: TrackTable<H,P,N,B,T,Q>(playlist: filteredPlaylists[i])) {
                    PlaylistRow(playlist: filteredPlaylists[i])
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Playlists...")
        .onAppear() {
            playlists = getPlaylists()
        }
        .navigationBarTitle("Playlists")
        .accentColor(.pumpyPink)
        .pumpyBackground()
    }
    
    var filteredPlaylists: [Playlist] {
        if searchText.isEmpty {
            return playlists
        } else {
            return playlists.filter { ($0.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    
}

struct PlaylistTable_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistTable<MockHomeVM,MockPlaylistManager,MockNowPlayingManager,MockBlockedTracks,MockTokenManager,MockQueueManager>(getPlaylists: {return []})
    }
}
