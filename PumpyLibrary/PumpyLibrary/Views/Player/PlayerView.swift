//
//  HomeView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct PlayerView<P: PlaylistProtocol,
                         Q:QueueProtocol,
                         N:NowPlayingProtocol,
                         B: BlockedTracksProtocol,
                         H:HomeProtocol,
                         T:TokenProtocol>: View {
    
    public init() {}

    @EnvironmentObject var homeVM: H
    @EnvironmentObject var nowPlayingManager: N
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Namespace var controls
    @Namespace var labels
    @Namespace var background
    @State private var measureRect = CGRect()
    @State private var notPlaying = true
    private let labelOpacity: CGFloat = 0.6
    
    public var body: some View {
        VStack {
            NavigationBar<B, N, H>().opacity(labelOpacity)
                .background(GeometryGetter(rect: $measureRect))
            if isPortrait() {
                portraitView
            } else  {
                landscapeView
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .accentColor(.pumpyPink)
        .playerBackground()
        .environmentObject(homeVM)
        .onReceive(nowPlayingManager.currentTrack.publisher) { _ in
            withAnimation {
                 notPlaying = (nowPlayingManager.currentTrack == nil)
            }
        }
    }
    
    // MARK: - Components
    
    @ViewBuilder
    var portraitView: some View {
        Spacer()
        switch homeVM.pageType {
        case .artwork:
            artwork(size: measureRect.width)
            Spacer(minLength: 20)
            TimeScrubber(opacity: labelOpacity)
        case .upNext:
            UpNextView<Q,N,B,T,P>()
                .padding(.horizontal, -20)
        }
        songDetailsAndControls.opacity(labelOpacity)
    }
    
    var landscapeView: some View {
        HStack(spacing: 5) {
            VStack {
                Spacer()
                artwork(size: (measureRect.width / 2) - 5)
                Spacer(minLength: 20)
                TimeScrubber(opacity: labelOpacity)
                songDetailsAndControls.opacity(labelOpacity)
            }
            VStack {
                UpNextView<Q,N,B,T,P>()
            }
        }
    }

    func artwork(size: CGFloat) -> some View {
        ArtworkView(collection: nowPlayingManager.currentTrack,
                    setBackground: true,
                    size: size)
    }
    
    @ViewBuilder
    var songDetailsAndControls: some View {
        Spacer(minLength: 20)
        SongLabels<N,P>()
            .id(labels)
            .frame(height: 55)
        Spacer(minLength: 20)
        PlayerControls<P,N,H,Q>(isPortrait: isPortrait(),
                                notPlaying: notPlaying)
            .id(controls)
    }
    
    // MARK: - Methods
    
    private func isPortrait() -> Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
}

// MARK: - Preview
#if DEBUG
struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            PlayerView<MockPlaylistManager,
                     MockQueueManager,
                     MockNowPlayingManager,
                     MockBlockedTracks,
                     MockHomeVM,
                     MockTokenManager>()
                .previewDisplayName("Portrait")
            PlayerView<MockPlaylistManager,
                     MockQueueManager,
                     MockNowPlayingManager,
                     MockBlockedTracks,
                     MockHomeVM,
                     MockTokenManager>()
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Landscape")
        }
            .environmentObject(MockPlaylistManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockHomeVM())
            .environmentObject(MockTokenManager())
            .environmentObject(MockHomeVM())
            .preferredColorScheme(.dark)
    }
}
#endif
