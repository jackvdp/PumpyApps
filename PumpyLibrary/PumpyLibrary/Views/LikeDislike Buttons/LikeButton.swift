//
//  LikeButton.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 06/08/2023.
//

import SwiftUI

struct LikeButton<
    N:NowPlayingProtocol
>: View {
    
    let track: Track
    @EnvironmentObject var bookmarkManager: BookmarkedManager
    var size: CGFloat
    
    var body: some View {
        Button(action: buttonPressed) {
            Image(systemName: "bookmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(
                    bookmarkManager.bookmarkedItems.contains(where: { $0.id == track.amStoreID}) ? .cyan : .white
                )
        }
        .buttonStyle(.plain)
        .disabled(track.codableTrack() == nil)
    }
    
    func buttonPressed() {
        guard let codableTrack = track.codableTrack() else { return }
        if bookmarkManager.bookmarkedItems.contains(where: { $0.id == track.amStoreID}) {
            bookmarkManager.removeItem(.track(codableTrack))
        } else {
            bookmarkManager.addTrackToBookmarks(.track(codableTrack))
        }
    }

}

#if DEBUG
struct LikeButton_Previews: PreviewProvider {
    
    static var bookmarkManagerWithTrack: BookmarkedManager {
        let manager = BookmarkedManager()
        manager.addTrackToBookmarks(.track(MockData.track.codableTrack()!))
        return manager
    }
    
    static var previews: some View {
        HStack(spacing: 24) {
            LikeButton<
                MockNowPlayingManager
            >(track: MockData.track, size: 30)
                .environmentObject(BookmarkedManager())
            LikeButton<
                MockNowPlayingManager
            >(track: MockData.track, size: 30)
                .environmentObject(bookmarkManagerWithTrack)
            DislikeButton<
                MockNowPlayingManager, MockBlockedTracks
            >(track: MockData.track, size: 30)
                .environmentObject(MockBlockedTracks())
        }
        .environmentObject(MockNowPlayingManager())
        .preferredColorScheme(.dark)
    }
}
#endif
