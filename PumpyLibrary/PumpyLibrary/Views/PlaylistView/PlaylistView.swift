//
//  TrackTable.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 30/11/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import AlertToast
import PumpyShared
import PumpyAnalytics

struct PlaylistView<
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var labManager: MusicLabManager
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var bookmarkManager: BookmarkedManager
    @EnvironmentObject var recentlyPlayedManager: RecentlyPlayedManager
    @EnvironmentObject var authManager: AuthorisationManager
    let playlist: Playlist
    @State private var searchText = ""
    
    var body: some View {
        PumpyList {
            VStack(spacing: 16) {
                artwork
                playlistName
                playButtons
                playlistDescription
            }
            tracksList
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Tracks...")
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { navBarButtons }
        .pumpyBackground()
    }
    
    // MARK: - Components
    
    @ViewBuilder var artwork: some View {
        if let url = playlist.artworkURL {
            let size: CGFloat = 200
            ArtworkView(url: url, size: size)
                .frame(width: size, height: size)
        } else { EmptyView() }
    }
    
    var playlistName: some View {
        VStack(spacing: 0) {
            Text(playlist.title ?? "Playlist")
                .font(.title3).bold()
            if playlist.curator != "" {
                Text(playlist.curator)
                    .font(.headline).bold().opacity(0.5)
            }
        }.multilineTextAlignment(.center)
    }
    
    var playButtons: some View {
        PlayCapsules(playNext: playNext, playNow: playNow)
    }
    
    @State private var showPlaylistDescriptionSheet = false
    
    var playlistDescription: some View {
        let songCount = playlist.songs.count == 1 ? "1 song" : "\(playlist.songs.count) songs"
        let description = showPlaylistDescriptionSheet ? playlist.longDescription : playlist.shortDescription
        let combinedText = description != nil ? songCount + " • " + description! : songCount
        return HTMLText(combinedText)
            .font(.footnote)
            .opacity(0.7)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(showPlaylistDescriptionSheet ? nil : 2)
            .onTapGesture {
                showPlaylistDescriptionSheet.toggle()
            }
    }
    
    var tracksList: some View {
        ForEach(filteredTracks.indices, id: \.self) { i in
            TrackRow<N,B,P,Q>(track: filteredTracks[i], authManager: authManager,
                              tapAction: {
                recentlyPlayedManager.addItem(.playlist(playlist.snaposhot()))
                playFromPosition(track: filteredTracks[i])
            })
        }
    }
    
    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    var navBarButtons: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                bookmarkManager.toggleBookmarkedItem(.playlist(playlist.snaposhot()))
            }, label: {
                Image(systemName: "bookmark")
            })
            .foregroundColor(
                bookmarkManager.bookmarkedItems.contains(.playlist(playlist.snaposhot())) ? .cyan : .white
            )
            .buttonStyle(.plain)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            AddToLibraryView<P>(playlist: playlist)
        }
    }
    
    // MARK: - Methods
    
    func playNext() {
        toastManager.showingPlayNextToast = true
        recentlyPlayedManager.addItem(.playlist(playlist.snaposhot()))
        playlistManager.playNext(playlist: playlist,
                                 secondaryPlaylists: [])
    }
    
    func playNow() {
        recentlyPlayedManager.addItem(.playlist(playlist.snaposhot()))
        playlistManager.playNow(playlist: playlist,
                                secondaryPlaylists: [])
    }
    
    func playFromPosition(track: Track) {
        if let playlistIndex = playlist
            .songs.firstIndex(where: { $0.amStoreID == track.amStoreID }) {
            playlistManager.playPlaylist(playlist: playlist, from: playlistIndex)
        }
    }
    
    var filteredTracks: [Track] {
        if searchText.isEmpty {
            return playlist.songs
        } else {
            return playlist.songs.filter {
                ($0.name).localizedCaseInsensitiveContains(searchText) ||
                ($0.artistName).localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

#if DEBUG
struct TrackTable_Previews: PreviewProvider {
    
    static var bookmarks: BookmarkedManager {
        let manager = BookmarkedManager()
        manager.addTrackToBookmarks(.playlist(MockData.playlist.snaposhot()))
        return manager
    }

    static var previews: some View {
        NavigationView {
                PlaylistView<MockPlaylistManager,
                           MockNowPlayingManager,
                           MockBlockedTracks,
                           MockQueueManager>(playlist: MockData.playlist)
        }
        .preferredColorScheme(.dark)
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockHomeVM())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockQueueManager())
        .environmentObject(MusicLabManager())
        .environmentObject(AlarmManager())
        .environmentObject(bookmarks)
    }
}
#endif
