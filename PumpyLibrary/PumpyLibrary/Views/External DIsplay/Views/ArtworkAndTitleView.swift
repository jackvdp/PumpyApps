//
//  ArtworkAndTitleView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI

public struct ExtArtworkAndTitleView<P:PlaylistProtocol,N:NowPlayingProtocol>: View {
    
    public init(geo: GeometryProxy) {
        self.geo = geo
    }
    
    let geo: GeometryProxy
    @EnvironmentObject var extDisMgr: ExternalDisplayManager<P>
    @EnvironmentObject var nowPlaying: N
    
    public var body: some View {
        if geo.size.height >= geo.size.width {
            VStack {
                ArtworkView(collection: nowPlaying.currentTrack, size: nil)
                    .padding(geo.size.height * 0.05)
                    .frame(height: extDisMgr.frameHeight(geo.size.height * 0.5))
                SongLabels<N,P>(size: geo.size.width * 0.03,
                           subFontOpacity: 0.5,
                           padding: geo.size.width * 0.005,
                           showNowPlaying: true,
                           showPlaylistLabel: false)
                    .padding(geo.size.height * 0.05)
                    .frame(height: extDisMgr.frameHeight(geo.size.height * 0.5))
            }
        } else {
            HStack {
                ArtworkView(collection: nowPlaying.currentTrack, size: nil)
                    .padding(geo.size.height * 0.05)
                    .frame(width: geo.size.width * 0.5)
                SongLabels<N,P>(size: geo.size.width * 0.03,
                           subFontOpacity: 0.5,
                           padding: geo.size.width * 0.005,
                           showNowPlaying: true,
                           showPlaylistLabel: false)
                    .padding(geo.size.height * 0.05)
                    .frame(width: geo.size.width * 0.5)
            }
        }
    }
}

#if DEBUG
//struct ArtworkTitleView_Previews: PreviewProvider {
//
//    static let musicManager = MockMusicMananger()
//    static let extDisManger = ExternalDisplayManager(username: "Test", playlistManager: musicManager.playlistManager)
//
//    static var previews: some View {
//        extDisManger.liveSettings.showQRCode = true
//        return Group {
//            ExtArtworkAndTitleView<MockPlaylistManager,MockNowPlayingManager>(geo: <#GeometryProxy#>)
//                .environmentObject(musicManager)
//                .environmentObject(extDisManger)
//                .previewLayout(.sizeThatFits)
//                .frame(width: 1920, height: 1080)
//            ExtArtworkAndTitleView<MockPlaylistManager,MockNowPlayingManager>(geo:)
//                .environmentObject(musicManager)
//                .environmentObject(extDisManger)
//                .previewLayout(.sizeThatFits)
//                .frame(width: 1080, height: 1920)
//        }
//    }
//}
#endif
