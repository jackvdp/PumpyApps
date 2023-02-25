//
//  TrackRow.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 02/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import MediaPlayer
import PumpyShared
import PumpyAnalytics

public struct TrackRow<T:TokenProtocol,
                       N:NowPlayingProtocol,
                       B:BlockedTracksProtocol,
                       P:PlaylistProtocol,
                       Q:QueueProtocol>: View {
    
    let track: PumpyAnalytics.Track
    let tapAction: (()->())?
    @State private var buttonTapped = false
    @EnvironmentObject var tokenManager: AuthorisationManager
    @EnvironmentObject var queueManager: Q

    public init(track: PumpyAnalytics.Track, tapAction: (()->())? = nil) {
        self.track = track
        self.tapAction = tapAction
    }
    
    var amTrack: ConstructedTrack? {
        if let am = track.appleMusicItem {
            return ConstructedTrack(playbackStoreID: am.id,
                                    isExplicitItem: false)
        }
        return nil
    }
    
    public var body: some View {
        if let action = tapAction {
            Button {
                flashRow()
                action()
            } label: {
                label
            }
            .buttonStyle(.plain)
            .foregroundColor(buttonTapped ? Color.pumpyPink : Color.primary)
        } else {
            label
        }
    }
    
    // MARK: - Components
    
    var label: some View {
        HStack(alignment: .center, spacing: 20.0) {
            ArtworkView(artworkURL: track.artworkURL, size: 60)
            trackDetails
            Spacer()
            if let amTrack {
                DislikeButton<N,B>(track: amTrack, size: 20)
                    .padding(.horizontal)
            }
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
                Text(track.title)
                    .font(.headline)
                    .lineLimit(1)
                if let amTrack, amTrack.isExplicitItem {
                    Image(systemName: "e.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12, alignment: .center)
                }
            }
            Text(track.artist)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    @ViewBuilder
    var menu: some View {
        if let amTrack {
            Button {
                queueManager.playTrackNow(id: amTrack.playbackStoreID)
            } label: {
                Label("Play Now", systemImage: "play.fill")
            }
            .padding()
            .foregroundColor(.pumpyPink)
            Button {
                queueManager.addTrackToQueue(ids: [amTrack.playbackStoreID])
            } label: {
                Label("Play Next", systemImage: "text.insert")
            }
            .padding()
            .foregroundColor(.pumpyPink)
        }
    }

    // MARK: - Flash Methods
    
    let flashDebouncer = Debouncer()
    
    func flashRow() {
        buttonTapped = true
        flashDebouncer.handle() {
            buttonTapped = false
        }
    }
}


struct TrackRow_Previews: PreviewProvider {
    
    static let track = PumpyAnalytics.MockData.trackWithFeatures
    
    static var previews: some View {
        TrackRow<MockTokenManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockPlaylistManager,
                 MockQueueManager>(track: track, tapAction: {})
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
