//
//  CollectionView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 05/09/2022.
//

import SwiftUI
import PumpyAnalytics

struct CollectionView<
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
    let collection: SuggestedCollection
    let bigSize: CGFloat = 300
    let smallSize: CGFloat = 200
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title.padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                items
            }
            .frame(height: conditionForBig() ? bigSize : smallSize)
        }
        .padding(.top)
    }
    
    var title: some View {
        Text(collection.title)
            .font(.title2.bold())
            .padding(.bottom)
    }
    
    var items: some View {
        LazyHGrid(rows: rows, alignment: .center, spacing: 20) {
            ForEach(collection.items, id: \.id) { item in
                ItemView<P,N,B,Q>(
                    item: item,
                    size: conditionForBig() ? Int(bigSize) : Int(smallSize)
                )
            }
        }
        .padding()
    }
    
    var rows: [GridItem] {
        [GridItem(.fixed(conditionForBig() ? bigSize : smallSize))]
    }
    
    func conditionForBig() -> Bool {
        if collection.title.contains("Made for You") { return false }
        return collection.types == [.playlists] || collection.types == [.stations]
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
                    CollectionView<MockPlaylistManager,
                                   MockNowPlayingManager,
                                   MockBlockedTracks,
                                   MockQueueManager>(collection: collection)
                }
            }
            .navigationTitle("Catalog")
        }
        .pumpyBackground()
        .listStyle(.plain)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
        
    }
}
