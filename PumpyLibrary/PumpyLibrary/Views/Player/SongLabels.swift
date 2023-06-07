//
//  SongLabelsView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct SongLabels<N: NowPlayingProtocol, P: PlaylistProtocol>: View {
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var playlistManager: P
    
    var size: CGFloat = 17
    var mainFontOpacity = 1.0
    var subFontOpacity = 1.0
    var padding: CGFloat = 0
    var fontWeight: Font.Weight?
    var showNowPlaying = false
    var showPlaylistLabel = true
    
    @State private var title = "Not playing..."
    @State private var artist = String()
    @State private var playlist = String()
    @State private var isExplicit = false
    
    public var body: some View {
        VStack(spacing: 5.0) {
            if showNowPlaying {
                label("Now playing", size: size * 0.75)
                    .opacity(subFontOpacity)
            }
            label(title, explicitLabel: isExplicit, size: size, bold: true)
                .opacity(nowPlayingManager.currentTrack != nil ? 1 : 0.5)
            label(artist, size: size)
                .opacity(subFontOpacity)
            if showPlaylistLabel {
                label(playlist, size: size)
                    .opacity(subFontOpacity)
            }
        }
        .onReceive(nowPlayingManager.currentTrack.publisher) { _ in
            withAnimation {
                title = nowPlayingManager.currentTrack?.name ?? "Not playing..."
                artist = nowPlayingManager.currentTrack?.artistName ?? ""
                isExplicit = nowPlayingManager.currentTrack?.isExplicitItem ?? false
            }
        }
        .onReceive(playlistManager.playlistLabel.publisher) { _ in
            withAnimation {
                playlist = playlistManager.playlistLabel
            }
        }
    }
    
    @ViewBuilder
    func label(_ text: String,
               explicitLabel: Bool = false,
               size: CGFloat,
               bold: Bool = false) -> some View {
        
        let text = bold ? Text(text).bold() : Text(text)
        if explicitLabel {
            HStack(spacing: 10.0) {
                text
                    .foregroundColor(Color.white)
                    .fontWeight(fontWeight)
                    .lineLimit(1)
                    .padding(padding)
                Image(systemName: "e.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color.white)
            }
        } else {
            text
                .foregroundColor(Color.white)
                .fontWeight(fontWeight)
                .lineLimit(1)
                .padding(padding)
        }
    }
}

#if DEBUG
struct SongLabels_Previews: PreviewProvider {

    static let nowPlayingManager = MockNowPlayingManager()
    static let playlistManager = MockPlaylistManager()
    
    static var previews: some View {
        nowPlayingManager.currentTrack = MockData.track
        playlistManager.playlistLabel = "Test Playlist"
        return SongLabels<MockNowPlayingManager, MockPlaylistManager>()
            .environmentObject(playlistManager)
            .environmentObject(nowPlayingManager)
    }
}
#endif
