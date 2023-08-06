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
    var nowPlayingManager: N?
    @EnvironmentObject var blockedTracksManager: B
    
    @State private var colour: Color = .white
    @State private var showAlert = false
    var size: CGFloat = 30
    
    var body: some View {
        Button(action: {
            if blockedTracksManager.unblockTrackOrAskToBlock(track: track.getBlockedTrack()) {
                showAlert = true
            }
        }) {
            Image(systemName: "hand.thumbsdown")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(colour)
        }
        .buttonStyle(.plain)
        .disabled(track.getBlockedTrack() == nil)
        .alert(isPresented: $showAlert, content: createAlert)
        .onReceive(blockedTracksManager.blockedTracks.publisher) { _ in
            setButton()
        }
        .onChange(of: nowPlayingManager?.currentTrack?.amStoreID) { _ in
            setButton()
        }
    }
    
    func setButton() {
        withAnimation {
            if blockedTracksManager.blockedTracks.contains(where: { $0.playbackID == track.amStoreID}) {
                colour = .red
            } else {
                colour = .white
            }
        }
    }
    
    func createAlert() -> Alert {
        return Alert(title: Text("Block \(track.name) by \(track.artistName)"),
                     message: Text("Blocked tracks will be removed from playback."),
                     primaryButton: .default(Text("Cancel"), action: {}),
                     secondaryButton: .destructive(Text("Block"),
                                                   action: {
            guard let track = track.getBlockedTrack() else { return }
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
        >(track: MockData.track)
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockNowPlayingManager())
            .preferredColorScheme(.dark)
    }
}
#endif

