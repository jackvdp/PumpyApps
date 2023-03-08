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

struct TrackTable<H:HomeProtocol,
                  P:PlaylistProtocol,
                  N:NowPlayingProtocol,
                  B:BlockedTracksProtocol,
                  T:TokenProtocol,
                  Q:QueueProtocol>: View {
    
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var homeVM: H
    let playlist: PumpyLibrary.Playlist
    @State private var showingPlayNextToast = false
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
        .pumpyBackground()
        .toast(isPresenting: $showingPlayNextToast) {
            playNextToast
        }
    }
    
    // MARK: - Components
    
    var artwork: some View {
        let size: CGFloat = 200
        return ArtworkView(artworkURL: playlist.artworkURL, size: size)
            .frame(width: size, height: size)
    }
    
    var playlistName: some View {
        Text(playlist.title ?? "Playlist")
            .font(.title3).bold()
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
            TrackRow<T,N,B,P,Q>(track: filteredTracks[i],
                                tapAction: { playFromPosition(track: filteredTracks[i]) })
        }
    }
    
    var playNextToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("plus", .pumpyPink),
                   title: "Playing Next")
    }
    
    // MARK: - Methods
    
    func playNext() {
        showingPlayNextToast = true
        playlistManager.playNext(playlist: playlist,
                                 secondaryPlaylists: [])
    }
    
    func playNow() {
        playlistManager.playNow(playlist: playlist,
                                secondaryPlaylists: [])
    }
    
    func playFromPosition(track: Track) {
        if let playlistIndex = playlist.songs.firstIndex(where: { $0.amStoreID == track.amStoreID }) {
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
    
    static var playlist: PreviewPlaylist {
        return MockData.playlist
    }

    static var previews: some View {
        NavigationView {
            VStack {
                TrackTable<MockHomeVM,
                           MockPlaylistManager,
                           MockNowPlayingManager,
                           MockBlockedTracks,
                           MockTokenManager,
                           MockQueueManager>(playlist: playlist)
            }
        }
        .preferredColorScheme(.dark)
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockHomeVM())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockTokenManager())
        .environmentObject(MockQueueManager())
        .environmentObject(AlarmManager())
    }
}
#endif
