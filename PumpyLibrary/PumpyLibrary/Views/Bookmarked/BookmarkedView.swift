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
        PumpyListForEach(bookmarkManager.bookmarkedItems, id: \.id) { item in
            switch item {
            case .track(let track):
                TrackRow<T,N,B,P,Q>(track: track)
            case .playlist(let snapshot):
                SnapshotView<T,N,B,P,Q>(snapshot: snapshot)
            }
        }
        .listStyle(.plain)
        .pumpyBackground()
        .navigationBarTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct BookmarkedView_Previews: PreviewProvider {
    
    static var bookmarkManager: BookmarkedManager {
        let manager = BookmarkedManager()
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

struct SnapshotView<
    T:TokenProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    P:PlaylistProtocol,
    Q:QueueProtocol
>: View {
    
    let snapshot: PlaylistSnapshot
    
    var body: some View {
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
    
}
