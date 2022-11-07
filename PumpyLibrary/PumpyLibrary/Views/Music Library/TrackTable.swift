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

struct TrackTable<H:HomeProtocol,
                  P:PlaylistProtocol,
                  N:NowPlayingProtocol,
                  B:BlockedTracksProtocol,
                  T:TokenProtocol,
                  Q:QueueProtocol>: View {
    
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var homeVM: H
    let playlist: PumpyLibrary.Playlist
    @State private var tracks = [PumpyLibrary.Track]()
    @State private var showingPlayNextToast = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    playlistHeader
                    tracksList
                }
                .padding(.leading)
            }
            capsuleButtons
        }
        .onAppear() {
            tracks = playlist.tracks
        }
        .navigationBarTitle(playlist.name ?? "")
        .toast(isPresenting: $showingPlayNextToast) {
            playNextToast
        }
    }
    
    var playlistHeader: some View {
        Text(tracks.count == 1 ? "1 song" : "\(tracks.count) songs")
            .font(.footnote)
            .foregroundColor(Color.gray)
    }
    
    var tracksList: some View {
        ForEach(tracks.indices, id: \.self) { i in
            Divider()
            TrackRow<T,N,B,P,Q>(track: tracks[i])
        }
    }
    
    var capsuleButtons: some View {
        PlayNextNowRow {
            playNext()
        } playNowAction: {
            playNow()
        }
    }
    
    func playNext() {
        self.showingPlayNextToast = true
        playlistManager.playNext(playlist: playlist,
                                 secondaryPlaylists: [])
    }
    
    func playNow() {
        playlistManager.playNow(playlist: playlist,
                                secondaryPlaylists: [])
    }
    
    var playNextToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("plus", .pumpyPink),
                   title: "Playing Next")
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
        .environmentObject(AlarmManager(username: "test", preview: true))
    }
}
#endif
