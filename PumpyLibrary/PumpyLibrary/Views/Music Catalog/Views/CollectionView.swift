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
    let bigSize: CGFloat = 300
    let smallSize: CGFloat = 200
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title
                .padding(.horizontal, 20)
            ScrollView(.horizontal) {
                items
            }
            .frame(height: conditionForBig() ? bigSize : smallSize)
        }
        .padding(.horizontal, -20)
    }
    
    var title: some View {
        Text(collection.title)
            .font(.title2.bold())
            .padding(.bottom)
    }
    
    var items: some View {
        LazyHGrid(rows: rows, alignment: .center, spacing: 20) {
            ForEach(collection.items, id: \.id) { item in
                ItemView<H,P,N,B,T,Q>(item: item,
                                      size: conditionForBig() ? Int(bigSize) : Int(smallSize))
            }
        }
        .padding()
    }
    
    var rows: [GridItem] {
        if conditionForBig() {
            return [GridItem(.fixed(bigSize))]
        } else {
            return [GridItem(.fixed(smallSize))]
        }
    }
    
    func conditionForBig() -> Bool {
        collection.types == [.playlists]
    }
}

struct CollectionView_Previews: PreviewProvider {
    
    static let collections = [
        PumpyAnalytics.MockData.collectionWithOneItem,
        PumpyAnalytics.MockData.albumCollection,
        PumpyAnalytics.MockData.collection
    ]
    
    static var previews: some View {
        NavigationView {
            PumpyList {
                ForEach(collections, id: \.self) { collection in
                    CollectionView<MockHomeVM,
                                   MockPlaylistManager,
                                   MockNowPlayingManager,
                                   MockBlockedTracks,
                                   MockTokenManager,
                                   MockQueueManager>(collection: collection)
                }
            }
            .navigationTitle("Catalog")
        }
        .listStyle(.plain)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
        
    }
}
