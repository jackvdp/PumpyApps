//
//  TrackTable.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 30/11/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import Combine
import MediaPlayer
import AlertToast
import PumpyAnalytics

struct TrackTable<H:HomeProtocol,
                  P:PlaylistProtocol,
                  N:NowPlayingProtocol,
                  B:BlockedTracksProtocol,
                  T:TokenProtocol,
                  Q:QueueProtocol>: View {
    
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var homeVM: H
    let playlist: PumpyAnalytics.Playlist
    @State private var showingPlayNextToast = false
    @State private var searchText = ""
    
    var body: some View {
        PumpyList {
            artwork
            playlistHeader
            capsuleButtons
            tracksList
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Tracks...")
        .navigationBarTitle(playlist.name ?? "Playlist")
        .toast(isPresenting: $showingPlayNextToast) {
            playNextToast
        }
    }
    
    // MARK: - Components
    
    var artwork: some View {
        let size: CGFloat = 200
        return ArtworkView(artworkURL: playlist.artworkURL, size: size)
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var playlistHeader: some View {
        Text(playlist.tracks.count == 1 ? "1 song" : "\(playlist.tracks.count) songs")
            .font(.footnote)
            .foregroundColor(Color.gray)
    }
    
    var tracksList: some View {
        ForEach(filteredTracks.indices, id: \.self) { i in
            TrackRow<T,N,B,P,Q>(track: filteredTracks[i],
                                tapAction: { playFromPosition(track: filteredTracks[i]) })
        }
    }
    
    var capsuleButtons: some View {
        PlayCapsules(playNext: playNext, playNow: playNow)
    }
    
    var playNextToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("plus", .pumpyPink),
                   title: "Playing Next")
    }
    
    // MARK: - Methods
    
    func playNext() {
        showingPlayNextToast = true
        
        playlistManager.playNext(playlist: libPlaylist,
                                 secondaryPlaylists: [])
    }
    
    func playNow() {
        playlistManager.playNow(playlist: libPlaylist,
                                secondaryPlaylists: [])
    }
    
    func playFromPosition(track: Track) {
        if let playlistIndex = libPlaylist.tracks.firstIndex(where: { $0.playbackStoreID == track.playbackStoreID }) {
            playlistManager.playPlaylist(playlist: libPlaylist, from: playlistIndex)
        }
    }
    
    var libPlaylist: ConstructedPlaylist {
        
        let tracks: [ConstructedTrack] = playlist.tracks.compactMap {
            guard let amItem = $0.appleMusicItem else { return nil }
            return ConstructedTrack(title: amItem.name,
                                    artist: amItem.artistName,
                                    artworkURL: amItem.artworkURL,
                                    playbackStoreID: amItem.id,
                                    isExplicitItem: false)
        }
        
        return ConstructedPlaylist(name: playlist.name,
                                   tracks: tracks,
                                   cloudGlobalID: nil,
                                   artworkURL: playlist.artworkURL)
        
    }
    
    var filteredTracks: [PumpyAnalytics.Track] {
        if searchText.isEmpty {
            return playlist.tracks
        } else {
            return playlist.tracks.filter {
                ($0.title).localizedCaseInsensitiveContains(searchText) ||
                ($0.artist).localizedCaseInsensitiveContains(searchText)
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
