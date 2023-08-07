//
//  DislikeButton.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 16/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct DislikeButton<
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol
>: View {
    
    let track: Track
    @EnvironmentObject var blockedTracksManager: B
    @State private var showAlert = false
    var size: CGFloat
    
    var body: some View {
        Button(action: {
            if blockedTracksManager.unblockTrackOrAskToBlock(track: track.codableTrack()) {
                showAlert = true
            }
        }) {
            Image(systemName: "hand.thumbsdown")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(
                    blockedTracksManager.blockedTracks.contains(where: { $0.playbackID == track.amStoreID}) ? .red : .white
                )
        }
        .buttonStyle(.plain)
        .disabled(track.codableTrack() == nil)
        .alert(isPresented: $showAlert, content: createAlert)
    }
    
    func createAlert() -> Alert {
        return Alert(title: Text("Block \(track.name) by \(track.artistName)"),
                     message: Text("Blocked tracks will be removed from playback."),
                     primaryButton: .default(Text("Cancel"), action: {}),
                     secondaryButton: .destructive(Text("Block"),
                                                   action: {
            guard let track = track.codableTrack() else { return }
            blockedTracksManager.addTrackToBlockedList(track)
        }))
    }

}

#if DEBUG
struct DislikeButton_Previews: PreviewProvider {
    
    static var previews: some View {
        DislikeButton<
            MockNowPlayingManager,
            MockBlockedTracks
        >(track: MockData.track, size: 30)
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockNowPlayingManager())
            .preferredColorScheme(.dark)
    }
}
#endif

