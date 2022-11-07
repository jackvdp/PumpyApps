//
//  SongLabelsView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct SongLabels<N: NowPlayingProtocol, P: PlaylistProtocol>: View {
    public init(size: CGFloat = 17, mainFont: String = K.Font.helvetica, subFont: String = K.Font.helveticaLight, mainFontOpacity: Double = 1.0, subFontOpacity: Double = 1.0, padding: CGFloat = 0, fontWeight: Font.Weight? = nil, showNowPlaying: Bool = false, showPlaylistLabel: Bool = true) {
        self.size = size
        self.mainFont = mainFont
        self.subFont = subFont
        self.mainFontOpacity = mainFontOpacity
        self.subFontOpacity = subFontOpacity
        self.padding = padding
        self.fontWeight = fontWeight
        self.showNowPlaying = showNowPlaying
        self.showPlaylistLabel = showPlaylistLabel
    }
    
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var playlistManager: P
    
    var size: CGFloat = 17
    var mainFont = K.Font.helvetica
    var subFont = K.Font.helveticaLight
    var mainFontOpacity = 1.0
    var subFontOpacity = 1.0
    var padding: CGFloat = 0
    var fontWeight: Font.Weight?
    var showNowPlaying = false
    var showPlaylistLabel = true
    
    @State private var title = String()
    @State private var artist = String()
    @State private var playlist = String()
    
    public var body: some View {
        VStack(spacing: 5.0) {
            if showNowPlaying {
                Text("Now playing")
                    .foregroundColor(Color.white)
                    .fontWeight(fontWeight)
                    .font(.custom(subFont, size: size * 0.75))
                    .lineLimit(1)
                    .opacity(subFontOpacity)
                    .padding(padding)
            }
            Text(title)
                .foregroundColor(Color.white)
                .fontWeight(fontWeight)
                .font(.custom(mainFont, size: size))
                .lineLimit(1)
                .padding(padding)
            Text(artist)
                .foregroundColor(Color.white)
                .fontWeight(fontWeight)
                .font(.custom(subFont, size: size))
                .lineLimit(1)
                .opacity(subFontOpacity)
                .padding(padding)
            if showPlaylistLabel {
                Text(playlist)
                    .foregroundColor(Color.white)
                    .fontWeight(fontWeight)
                    .font(.custom(subFont, size: size))
                    .lineLimit(1)
                    .opacity(subFontOpacity)
            }
        }
        .onChange(of: nowPlayingManager.currentTrack) { _ in
            withAnimation {
                title = nowPlayingManager.currentTrack?.title ?? ""
                artist = nowPlayingManager.currentTrack?.artist ?? ""
            }
        }
        .onChange(of: playlistManager.playlistLabel) { newValue in
            withAnimation {
                playlist = newValue
            }
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
