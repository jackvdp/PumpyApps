//
//  HomeView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/12/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct HomeView<P: PlaylistProtocol,
                       Q:QueueProtocol,
                       N:NowPlayingProtocol,
                       B: BlockedTracksProtocol,
                       H:HomeProtocol,
                       T:TokenProtocol,
                       V: View>: View {
    
    public init(homeVM: H, menuView: V) {
        self._homeVM = StateObject(wrappedValue: homeVM)
        self.menuView = menuView
    }
    
    @StateObject var homeVM: H
    @EnvironmentObject var nowPlayingManager: N
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Namespace var controls
    @Namespace var labels
    @Namespace var background
    let menuView: V
    @State private var measureRect = CGRect()
    @State private var notPlaying = true
    
    public var body: some View {
        VStack {
            NavigationBar<B, N, H, V>(destinationView: menuView)
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
        .background(artwork.background)
        .environmentObject(homeVM)
        .onChange(of: nowPlayingManager.currentTrack) { newValue in
            withAnimation {
                 notPlaying = newValue == nil
            }
        }
    }
    
    @ViewBuilder
    var portraitView: some View {
        Spacer()
        switch homeVM.pageType {
        case .artwork:
            artwork
        case .upNext:
            UpNextView<Q,N,B,T,P>()
                .padding(.horizontal, -20)
        }
        songDetailsAndControls
    }
    
    var landscapeView: some View {
        HStack(spacing: 5) {
            VStack {
                Spacer()
                artwork
                songDetailsAndControls
            }
            VStack {
                UpNextView<Q,N,B,T,P>()
            }
        }
    }
    
    var artwork: ArtworkView {
        ArtworkView(artworkURL: nowPlayingManager.currentTrack?.artworkURL,
                    size: measureRect.width)
    }
    
    @ViewBuilder
    var songDetailsAndControls: some View {
        Spacer(minLength: 20)
        SongLabels<N,P>()
            .id(labels)
            .frame(height: 55)
        Spacer(minLength: 20)
        PlayerControls<P,N,H,Q>(isPortrait: isPortrait(), notPlaying: notPlaying)
            .id(controls)
        Spacer(minLength: 20)
        VolumeControl()
    }
    
    func isPortrait() -> Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }

}

// MARK: - Preview
#if DEBUG
struct HomeView_Previews: PreviewProvider {

    static let homeVM = MockHomeVM()
    
    static var previews: some View {
        HomeView<MockPlaylistManager,
                 MockQueueManager,
                 MockNowPlayingManager,
                 MockBlockedTracks,
                 MockHomeVM,
                 MockTokenManager,
                 EmptyView>(homeVM: homeVM, menuView: EmptyView())
            .environmentObject(MockPlaylistManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockHomeVM())
            .environmentObject(MockTokenManager())
            .preferredColorScheme(.dark)
    }
}
#endif
