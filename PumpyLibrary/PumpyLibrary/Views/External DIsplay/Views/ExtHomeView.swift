//
//  HomeView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct ExtHomeView<P:PlaylistProtocol,N:NowPlayingProtocol, Q:QueueProtocol,B:BlockedTracksProtocol,T:TokenProtocol>: View {
    
    @EnvironmentObject var extDisMgr: ExternalDisplayManager<P>
    @EnvironmentObject var nowPlaying: N
    
    var body: some View {
        GeometryReader { geo in
            ZStack() {
                ArtworkView(collection: nowPlaying.currentTrack, size: nil)
                VStack {
                    switch extDisMgr.liveSettings.displayContent {
                    case .artworkAndTitles:
                        ExtArtworkAndTitleView<P,N>(geo: geo)
                            .frame(height: extDisMgr.frameHeight(geo.size.height))
                    case .upNextArtwokAndTitles:
                        UpNextArtworkView<N,P,B,Q,T>(geo: geo)
                            .frame(height: extDisMgr.frameHeight(geo.size.height))
                    case .upNext:
                        UpNextView<Q,N,B,T,P>(fontStyle: .custom(K.Font.helveticaLight, size: geo.size.width * 0.03 * 0.75), opacity: 0.5, showButton: false)
                            .padding(geo.size.height * 0.05)
                            .frame(height: extDisMgr.frameHeight(geo.size.height))
                    }
                    if extDisMgr.liveSettings.showQRCode {
                        QRCodeView<P>(width: geo.size.width, height: geo.size.height)
                            .frame(height: geo.size.height * 0.2)
                    }
                }
            }
        }
    }

}

struct ExHomeView_Previews: PreviewProvider {
    
    static let extDisManger = ExternalDisplayManager(username: .account("Test"), playlistManager: MockPlaylistManager())
    
    static var previews: some View {
        extDisManger.liveSettings.displayContent = .upNext
        return Group {
            ExtHomeView<MockPlaylistManager,MockNowPlayingManager,MockQueueManager,MockBlockedTracks,MockTokenManager>()
                .environmentObject(MockMusicMananger())
                .environmentObject(extDisManger)
                .previewLayout(.sizeThatFits)
                .frame(width: 1920, height: 1080)
            ExtHomeView<MockPlaylistManager,MockNowPlayingManager,MockQueueManager,MockBlockedTracks,MockTokenManager>()
                .environmentObject(MockMusicMananger())
                .environmentObject(extDisManger)
                .previewLayout(.sizeThatFits)
                .frame(width: 1080, height: 1920)
        }
    }
}


