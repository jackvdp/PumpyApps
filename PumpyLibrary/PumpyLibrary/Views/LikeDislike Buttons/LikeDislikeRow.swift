//
//  LikeDislikeRow.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 06/08/2023.
//

import SwiftUI

struct LikeDislikeButtons<
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol
>: View {
    
    let track: Track
    var nowPlayingManager: N?
    var size: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 24) {
            LikeButton<N>(
                track: track,
                nowPlayingManager: nowPlayingManager,
                size: size
            )
            DislikeButton<N,B>(
                track: track,
                nowPlayingManager: nowPlayingManager,
                size: size
            )
        }
    }
    
}

#if DEBUG
struct LikeDislikeButton_Previews: PreviewProvider {
    
    static var bookmarkManagerWithTrack: BookmarkedManager {
        let manager = BookmarkedManager()
        manager.addTrackToBookmarks(.track(MockData.track.getBlockedTrack()!))
        return manager
    }
    
    static var previews: some View {
        LikeDislikeButtons<
            MockNowPlayingManager, MockBlockedTracks
        >(track: MockData.track)
            .environmentObject(bookmarkManagerWithTrack)
            .environmentObject(MockBlockedTracks())
            .preferredColorScheme(.dark)
    }
}
#endif
