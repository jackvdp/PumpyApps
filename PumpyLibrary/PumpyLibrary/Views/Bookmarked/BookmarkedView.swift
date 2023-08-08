//
//  BookmarkedView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 04/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct BookmarkedView<
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    P:PlaylistProtocol,
    Q:QueueProtocol
>: View {
    
    @EnvironmentObject var bookmarkManager: BookmarkedManager
    @EnvironmentObject var queueManager: Q
    @State private var showAlert = false
    
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
                        TrackRow<N,B,P,Q>(track: track) {
                            queueManager.playTrackNow(id: track.playbackID)
                        }
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
        .navigationBarItems(trailing: Button(action: {
            showAlert = true
        }, label: { Text("Reset") }))
        .alert(isPresented: $showAlert) {
            createAlert()
        }
    }
    
    func snapshotView(_ snapshot: PlaylistSnapshot) -> some View {
        NavigationLink(destination: ItemDetailView<P,N,B,Q>(snapshot: snapshot)) {
            HStack(spacing: 20) {
                ArtworkView(url: snapshot.artworkURL, size: 80)
                VStack(alignment: .leading, spacing: 5) {
                    Text(snapshot.name ?? "Playlist")
                        .font(.headline)
                        .lineLimit(1)
                    if let curator = snapshot.curator {
                        Text(curator)
                            .font(.subheadline)
                            .opacity(0.5)
                            .lineLimit(1)
                    }
                }
                Spacer()
            }
        }
    }
    
    func onDelete(_ offsets: IndexSet) {
        offsets.forEach { i in
            if let item = bookmarkManager.bookmarkedItems[safe: i] {
                bookmarkManager.removeItem(item)
            }
        }
    }
    
    func createAlert() -> Alert {
         Alert(
            title: Text("Remove all bookmarks?"),
            message: Text("This cannot be undone."),
            primaryButton: .default(Text("Cancel"), action: {}),
            secondaryButton: .destructive(Text("Remove"), action: bookmarkManager.removeAll)
         )
    }
}

struct BookmarkedView_Previews: PreviewProvider {
    
    static var bookmarkManager: BookmarkedManager {
        let manager = BookmarkedManager()
        manager.addTrackToBookmarks(.playlist(PumpyAnalytics.MockData.snapshot))
        manager.addTrackToBookmarks(.track(MockData.track.codableTrack()!))
        manager.addTrackToBookmarks(.track(MockData.track.codableTrack()!))
        return manager
    }
    
    static var previews: some View {
        NavigationView {
            BookmarkedView<MockNowPlayingManager,
                           MockBlockedTracks,
                           MockPlaylistManager,
                           MockQueueManager>()
        }
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockQueueManager())
        .environmentObject(MockPlaylistManager())
        .environmentObject(AuthorisationManager())
        .environmentObject(bookmarkManager)
        .preferredColorScheme(.dark)
        .accentColor(.pumpyPink)
    }
}
