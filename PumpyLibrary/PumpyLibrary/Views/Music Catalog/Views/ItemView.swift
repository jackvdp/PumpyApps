//
//  ItemView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 05/09/2022.
//

import SwiftUI
import PumpyAnalytics

struct ItemView<H:HomeProtocol,
                P:PlaylistProtocol,
                N:NowPlayingProtocol,
                B:BlockedTracksProtocol,
                T:TokenProtocol,
                Q:QueueProtocol>: View {
    
    let item: SuggestedItem
    let size: Int
    
    var body: some View {
        NavigationLink(destination: ItemDetailView<H,P,N,B,T,Q>(snapshot: snapshot)) {
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
        ItemView<MockHomeVM,
                 MockPlaylistManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockTokenManager,
                 MockQueueManager>(item: PumpyAnalytics.MockData.item, size: 200)
            .preferredColorScheme(.dark)
            .frame(height: 100)
            .previewLayout(.sizeThatFits)
            .border(Color.red)
        ItemView<MockHomeVM,
                 MockPlaylistManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockTokenManager,
                 MockQueueManager>(item: PumpyAnalytics.MockData.item, size: 200)
            .preferredColorScheme(.dark)
            .frame(height: 200)
            .previewLayout(.sizeThatFits)
        ItemView<MockHomeVM,
                 MockPlaylistManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockTokenManager,
                 MockQueueManager>(item: PumpyAnalytics.MockData.item, size: 200)
            .preferredColorScheme(.dark)
            .frame(height: 400)
            .previewLayout(.sizeThatFits)
    }
}
