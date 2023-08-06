//
//  BookmarkedView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 04/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct BookmarkedView<
    T:TokenProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    P:PlaylistProtocol,
    Q:QueueProtocol
>: View {
    
    @EnvironmentObject var bookmarkManager: BookmarkedManager
    
    var body: some View {
        Group {
            if bookmarkManager.bookmarkedItems.isEmpty {
                Text("No Bookmarked Items")
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)
            } else {
                PumpyListForEach(bookmarkManager.bookmarkedItems, id: \.id, onDelete: onDelete) { item in
                    switch item {
                    case .track(let track):
                        TrackRow<T,N,B,P,Q>(track: track)
                    case .playlist(let snapshot):
                        snapshotView(snapshot)
                    }
                }
            }
        }
        .listStyle(.plain)
        .pumpyBackground()
        .navigationBarTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
    }
    
    func snapshotView(_ snapshot: PlaylistSnapshot) -> some View {
        NavigationLink(destination: ItemDetailView<P,N,B,T,Q>(snapshot: snapshot)) {
            HStack {
                ArtworkView(url: snapshot.artworkURL, size: 80)
                Text(snapshot.name ?? "Playlist")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
            }
        }
    }
    
    func onDelete(_ index: IndexSet) {
        
    }
}

struct BookmarkedView_Previews: PreviewProvider {
    
    static var bookmarkManager: BookmarkedManager {
        let manager = BookmarkedManager()
        manager.addTrackToBookmarks(.playlist(PumpyAnalytics.MockData.snapshot))
        manager.addTrackToBookmarks(.track(MockData.track.getBlockedTrack()!))
        manager.addTrackToBookmarks(.track(MockData.track.getBlockedTrack()!))
        return manager
    }
    
    static var previews: some View {
        NavigationView {
            BookmarkedView<MockTokenManager,
                           MockNowPlayingManager,
                           MockBlockedTracks,
                           MockPlaylistManager,
                           MockQueueManager>()
        }
        .environmentObject(MockTokenManager())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockQueueManager())
        .environmentObject(MockPlaylistManager())
        .environmentObject(bookmarkManager)
        .preferredColorScheme(.dark)
        .accentColor(.pumpyPink)
    }
}
