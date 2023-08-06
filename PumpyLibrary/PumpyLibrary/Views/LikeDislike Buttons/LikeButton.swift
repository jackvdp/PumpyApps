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
    var nowPlayingManager: N?
    @EnvironmentObject var bookmarkManager: BookmarkedManager
    @State private var colour: Color = .white
    var size: CGFloat = 30
    
    var body: some View {
        Button(action: buttonPressed) {
            Image(systemName: "hand.thumbsup")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(colour)
        }
        .buttonStyle(.plain)
        .disabled(track.getBlockedTrack() == nil)
        .onReceive(bookmarkManager.$bookmarkedItems) { _ in
            setButton()
        }
        .onChange(of: nowPlayingManager?.currentTrack?.amStoreID) { _ in
            setButton()
        }
    }
    
    func buttonPressed() {
        guard let codableTrack = track.getBlockedTrack() else { return }
        if bookmarkManager.bookmarkedItems.contains(where: { $0.id == track.amStoreID}) {
            bookmarkManager.removeItem(.track(codableTrack))
        } else {
            bookmarkManager.addTrackToBookmarks(.track(codableTrack))
        }
    }
    
    func setButton() {
        withAnimation {
            if bookmarkManager.bookmarkedItems.contains(where: { $0.id == track.amStoreID}) {
                colour = .cyan
            } else {
                colour = .white
            }
        }
    }

}

#if DEBUG
struct LikeButton_Previews: PreviewProvider {
    
    static var bookmarkManagerWithTrack: BookmarkedManager {
        let manager = BookmarkedManager()
        manager.addTrackToBookmarks(.track(MockData.track.getBlockedTrack()!))
        return manager
    }
    
    static var previews: some View {
        HStack(spacing: 24) {
            LikeButton<
                MockNowPlayingManager
            >(track: MockData.track)
                .environmentObject(BookmarkedManager())
            LikeButton<
                MockNowPlayingManager
            >(track: MockData.track)
                .environmentObject(bookmarkManagerWithTrack)
            DislikeButton<
                MockNowPlayingManager, MockBlockedTracks
            >(track: MockData.track)
                .environmentObject(MockBlockedTracks())
        }
        .environmentObject(MockNowPlayingManager())
        .preferredColorScheme(.dark)
    }
}
#endif
