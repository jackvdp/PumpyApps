//
//  CollectionView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 05/09/2022.
//

import SwiftUI
import PumpyAnalytics

struct CollectionView<H:HomeProtocol,
                      P:PlaylistProtocol,
                      N:NowPlayingProtocol,
                      B:BlockedTracksProtocol,
                      T:TokenProtocol,
                      Q:QueueProtocol>: View {
    
    let collection: SuggestedCollection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title
            ScrollView(.horizontal) {
                items
            }
            .frame(height: conditionForBig() ? 300 : 200)
        }
    }
    
    var title: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(collection.title)
                .font(.title2.bold())
            Divider()
        }
        .padding(.leading)
    }
    
    var items: some View {
        LazyHGrid(rows: rows, alignment: .center, spacing: 20) {
            ForEach(collection.items, id: \.id) { item in
                ItemView<H,P,N,B,T,Q>(item: item,
                                      size: conditionForBig() ? 300 : 200)
            }
        }
        .padding()
    }
    
    var rows: [GridItem] {
        if conditionForBig() {
            return [GridItem(.fixed(250))]
        } else {
            return [GridItem(.fixed(150))]
        }
    }
    
    func conditionForBig() -> Bool {
        collection.types == [.playlists]
    }
}

struct CollectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            NavigationView {
                ScrollView {
                    CollectionView<MockHomeVM,
                                   MockPlaylistManager,
                                   MockNowPlayingManager,
                                   MockBlockedTracks,
                                   MockTokenManager,
                                   MockQueueManager>(collection: PumpyAnalytics.MockData.collectionWithOneItem)
                    CollectionView<MockHomeVM,
                                    MockPlaylistManager,
                                    MockNowPlayingManager,
                                    MockBlockedTracks,
                                    MockTokenManager,
                                    MockQueueManager>(collection: PumpyAnalytics.MockData.albumCollection)
                    CollectionView<MockHomeVM,
                                   MockPlaylistManager,
                                   MockNowPlayingManager,
                                   MockBlockedTracks,
                                   MockTokenManager,
                                   MockQueueManager>(collection: PumpyAnalytics.MockData.collectionWithOneItem)
                }
                .padding()
                .navigationTitle("Catalog")
            }
            
        }
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
        
    }
}
