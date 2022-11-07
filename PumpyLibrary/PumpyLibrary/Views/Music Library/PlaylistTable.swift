//
//  PlaylistTable.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 30/11/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import Introspect

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
    @State private var tableView: UITableView?
    var getPlaylists: ()->[Playlist]

    public var body: some View {
        List {
            ForEach(playlists.indices, id: \.self) { i in
                NavigationLink(destination: TrackTable<H,P,N,B,T,Q>(playlist: playlists[i])) {
                    PlaylistRow(playlist: playlists[i])
                }
            }
        }
        .listStyle(.plain)
        .onAppear() {
            deselectRows()
            playlists = getPlaylists()
        }
        .navigationBarTitle("Playlists")
        .accentColor(.pumpyPink)
        .introspectTableView(customize: { tableView in
            self.tableView = tableView
        })
    }
    
    private func deselectRows() {
        if let tableView = tableView, let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
}

struct PlaylistTable_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistTable<MockHomeVM,MockPlaylistManager,MockNowPlayingManager,MockBlockedTracks,MockTokenManager,MockQueueManager>(getPlaylists: {return []})
    }
}
