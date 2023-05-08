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
    @EnvironmentObject var labManager: MusicLabManager
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var homeVM: H
    let playlist: PumpyLibrary.Playlist
    @State private var searchText = ""
    var libraryPlaylist = false
    @State private var libraryTracks = [PumpyLibrary.Track]()
    
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
        .labManagerToolbar(destination: MusicLabView<N,B,T,Q,P,H>())
        .pumpyBackground()
        .task {
            if libraryPlaylist {
                libraryTracks = await playlistManager.getLibraryPlaylistTracks(playlist: playlist)
            }
        }
    }
    
    var playlistTracks: [PumpyLibrary.Track] {
        libraryTracks.isEmpty ? playlist.songs : libraryTracks
    }
    
    // MARK: - Components
    
    @ViewBuilder var artwork: some View {
        if let url = playlist.artworkURL {
            let size: CGFloat = 200
            ArtworkView(artworkURL: url, size: size)
                .frame(width: size, height: size)
        } else { EmptyView() }
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
        let songCount = playlistTracks.count == 1 ? "1 song" : "\(playlistTracks.count) songs"
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
    
    // MARK: - Methods
    
    func playNext() {
        toastManager.showingPlayNextToast = true
        playlistManager.playPlaylist(playlist, when: .next)
    }
    
    func playNow() {
        playlistManager.playPlaylist(playlist, when: .now)
    }
    
    func playFromPosition(track: Track) {
        if let playlistIndex = playlist
            .songs.firstIndex(where: { $0.amStoreID == track.amStoreID }) {
            playlistManager.playPlaylist(playlist, when: .at(playlistIndex))
        }
    }
    
    var filteredTracks: [Track] {
        if searchText.isEmpty {
            return playlistTracks
        } else {
            return playlistTracks.filter {
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
                TrackTable<MockHomeVM,
                           MockPlaylistManager,
                           MockNowPlayingManager,
                           MockBlockedTracks,
                           MockTokenManager,
                           MockQueueManager>(playlist: playlist)
        }
        .preferredColorScheme(.dark)
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockHomeVM())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockTokenManager())
        .environmentObject(MockQueueManager())
        .environmentObject(MusicLabManager())
        .environmentObject(AlarmManager())
    }
}
#endif
