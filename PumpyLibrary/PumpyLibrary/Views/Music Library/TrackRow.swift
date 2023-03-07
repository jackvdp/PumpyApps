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
    
    let track: Track
    let tapAction: (()->())?
    @State private var buttonTapped = false
    @State private var trackAMID: String?
    @EnvironmentObject var tokenManager: AuthorisationManager
    @EnvironmentObject var queueManager: Q

    public init(track: Track, tapAction: (()->())? = nil) {
        self.track = track
        self.tapAction = tapAction
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
            DislikeButton<N,B>(track: track, size: 20)
                .padding(.horizontal)
        }
        .opacity(trackAMID != nil ? 1 : 0.3)
        .background {
            analyticsInfo
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
        .onAppear() {
            trackAMID = track.amStoreID
        }
    }
    
    var trackDetails: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack(alignment: .center, spacing: 10.0) {
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                if track.isExplicitItem {
                    Image(systemName: "e.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12, alignment: .center)
                }
            }
            Text(track.artistName)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    /// Used to track new data for matching
    @ViewBuilder
    var analyticsInfo: some View {
        if let analyticsTrack = track as? PumpyAnalytics.Track {
            EmptyView()
                .frame(width: 0, height: 0)
                .onReceive(analyticsTrack.$appleMusicItem) { newValue in
                    if let myID = newValue?.id {
                        withAnimation {
                            trackAMID = myID
                        }
                    }
                }
        }
    }
    
    // MARK: - Preview Menu
    
    @ViewBuilder
    var menu: some View {
        if let id = track.amStoreID {
            trackMenu(appleId: id)
        } else {
            missingTrackMenu
        }
    }
    
    @ViewBuilder
    func trackMenu(appleId: String) -> some View {
        Button {
            queueManager.playTrackNow(id: appleId)
        } label: {
            Label("Play Now", systemImage: "play.fill")
        }
        .padding()
        .foregroundColor(.pumpyPink)
        Button {
            queueManager.addTrackToQueue(ids: [appleId])
        } label: {
            Label("Play Next", systemImage: "text.insert")
        }
        .padding()
        .foregroundColor(.pumpyPink)
    }
    
    @ViewBuilder var missingTrackMenu: some View {
        if (track as? PumpyAnalytics.Track)?.inProgress.gettingAM ?? false {
            Text("Matching...").opacity(0.5)
        } else {
            Text("Track not matched to Apple Music").opacity(0.5)
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

// MARK: - Preview

struct TrackRow_Previews: PreviewProvider {
    
    static let track = MockData.track
    
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
