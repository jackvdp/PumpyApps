//
//  PlaylistGrid.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 07/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct PlaylistGrid<
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
    let playlists: [PlaylistSnapshot]
    var oneRow: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: playlistRows, alignment: .center, spacing: 20) {
                ForEach(playlists, id: \.sourceID) { item in
                    NavigationLink(destination: ItemDetailView<P,N,B,Q>(snapshot: item)) {
                        ItemGridComponent(name: item.name ?? "",
                                          curator: item.curator ?? "",
                                          itemArtworkURL: item.artworkURL ?? "",
                                          size: 200)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    var playlistRows: [GridItem] {
        Array(repeating: GridItem(.fixed(200)),
              count: (playlists.count == 1 || oneRow) ? 1 : 2)
    }
}

struct PlaylistGrid_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistGrid<
            MockPlaylistManager,
            MockNowPlayingManager,
            MockBlockedTracks,
            MockQueueManager
        >(
            playlists: PumpyAnalytics.MockData.snapshots
        )
    }
}
