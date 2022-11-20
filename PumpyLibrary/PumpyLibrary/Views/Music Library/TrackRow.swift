//
//  TrackRow.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 02/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import MediaPlayer

public struct TrackRow<T:TokenProtocol,
                       N:NowPlayingProtocol,
                       B:BlockedTracksProtocol,
                       P:PlaylistProtocol,
                       Q:QueueProtocol>: View {
    
    @EnvironmentObject var tokenManager: T
    @EnvironmentObject var queueManager: Q
    let track: Track

    public init(track: Track) {
        self.track = track
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            ArtworkView(artworkURL: track.artworkURL, size: 60)
            trackDetails
            Spacer()
            DislikeButton<N,B>(track: track, size: 20)
                .padding(.horizontal)
        }
        .onAppear() {
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().backgroundColor = .clear
        }
        .contentShape(Rectangle())
        .contextWithPreview {
            menu
        } preview: {
            TrackPreview(track: track)
                .environmentObject(tokenManager)
        }
    }
    
    var trackDetails: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack(alignment: .center, spacing: 10.0) {
                Text(track.title ?? "")
                    .font(.headline)
                    .lineLimit(1)
                if track.isExplicitItem {
                    Image(systemName: "e.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12, alignment: .center)
                }
            }
            Text(track.artist ?? "N/A")
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    @ViewBuilder
    var menu: some View {
        Button {
            queueManager.playTrackNow(id: track.playbackStoreID)
        } label: {
            Label("Play Now", systemImage: "play.fill")
        }
        .padding()
        .foregroundColor(.pumpyPink)
        Button {
            queueManager.addTrackToQueue(ids: [track.playbackStoreID])
        } label: {
            Label("Play Next", systemImage: "text.insert")
        }
        .padding()
        .foregroundColor(.pumpyPink)
    }

}


struct TrackRow_Previews: PreviewProvider {
    
    static let track = MockData.track
    
    static var previews: some View {
        TrackRow<MockTokenManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockPlaylistManager,
                 MockQueueManager>(track: track)
            .environmentObject(MockTokenManager())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .preferredColorScheme(.dark)
        TrackRow<MockTokenManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockPlaylistManager,
                 MockQueueManager>(track: track).menu
            .environmentObject(MockTokenManager())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .preferredColorScheme(.dark)
    }
}
