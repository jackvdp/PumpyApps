//
//  ItemView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 05/09/2022.
//

import SwiftUI
import PumpyAnalytics

struct ItemView<P:PlaylistProtocol,
                N:NowPlayingProtocol,
                B:BlockedTracksProtocol,
                Q:QueueProtocol>: View {
    
    let item: SuggestedItem
    let size: Int
    
    var body: some View {
        NavigationLink(destination: ItemDetailView<P,N,B,Q>(snapshot: snapshot)) {
            ItemGridComponent(name: item.name,
                              curator: item.curator,
                              itemArtworkURL: item.artworkURL,
                              size: size)
        }
        .buttonStyle(.plain)
    }
    
    var snapshot: PlaylistSnapshot {
        PlaylistSnapshot(sourceID: item.id,
                         type: .am(id: item.id))
    }
    
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView<MockPlaylistManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockQueueManager>(item: PumpyAnalytics.MockData.item, size: 200)
            .preferredColorScheme(.dark)
            .frame(height: 100)
            .previewLayout(.sizeThatFits)
            .border(Color.red)
        ItemView<MockPlaylistManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockQueueManager>(item: PumpyAnalytics.MockData.item, size: 200)
            .preferredColorScheme(.dark)
            .frame(height: 200)
            .previewLayout(.sizeThatFits)
        ItemView<MockPlaylistManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockQueueManager>(item: PumpyAnalytics.MockData.item, size: 200)
            .preferredColorScheme(.dark)
            .frame(height: 400)
            .previewLayout(.sizeThatFits)
    }
}
