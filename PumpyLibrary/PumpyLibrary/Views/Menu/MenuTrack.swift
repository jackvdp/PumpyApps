//
//  MenuTrack.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 24/08/2022.
//

import SwiftUI

public struct MenuTrackView<T:TokenProtocol,
                            N:NowPlayingProtocol,
                            B:BlockedTracksProtocol,
                            P:PlaylistProtocol>: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var blockedTracksManager: B
    @EnvironmentObject var tokenManager: T
    @EnvironmentObject var playlistManager: P
    
    public init() { }
    
    public var body: some View {
        VStack {
            Divider()
            trackDetails
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .background(artwork.background)
    }
    
    var trackDetails: some View {
        HStack(alignment: .center, spacing: 20.0) {
            artwork
            songDetails
            Spacer()
            if let track = nowPlayingManager.currentTrack {
                dislikeButton(track: track)
            }
        }
        .padding(.horizontal)
    }
    
    var artwork: ArtworkView {
        ArtworkView(artworkURL: nowPlayingManager.currentTrack?.artworkURL, size: 50)
    }
        
    var songDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10.0) {
                Text(nowPlayingManager.currentTrack?.title ?? "N/A")
                    .font(.headline)
                    .lineLimit(1)
                if nowPlayingManager.currentTrack?.isExplicitItem ?? false {
                    Image(systemName: "e.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12, alignment: .center)
                }
            }
            Text(nowPlayingManager.currentTrack?.artist ?? "N/A")
                .font(.subheadline)
                .lineLimit(1)
            Text(playlistManager.playlistLabel)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    func dislikeButton(track: Track) -> some View {
        DislikeButton<N,B>(track: track, size: 20)
            .padding(.horizontal)
    }
}

struct MenuTrack_Previews: PreviewProvider {
    static var previews: some View {
        MenuTrackView<MockTokenManager,
                      MockNowPlayingManager,
                      MockBlockedTracks,
                      MockPlaylistManager
        >()
            .environmentObject(MockTokenManager())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockPlaylistManager())
    }
}
