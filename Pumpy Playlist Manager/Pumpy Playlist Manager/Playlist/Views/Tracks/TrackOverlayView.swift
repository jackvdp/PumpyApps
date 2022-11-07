//
//  TrackOverlayView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 20/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct HoveringView: View {
    
    @EnvironmentObject var playerManager: PlayerManager
    @Binding var isHovering: Bool
    var playSize: CGFloat = 20
    let track: Track
    
    var body: some View {
        ZStack {
            if track == playerManager.currentTrack {
                OverlayView(imageName: playerManager.playerState.rawValue, playSize: playSize)
            } else {
                if isHovering {
                    OverlayView(imageName: PlayerState.notPlaying.rawValue, playSize: playSize)
                } else {
                    EmptyView()
                }
            }
        }
        .onTapGesture {
            if playerManager.currentTrack == track {
                playerManager.playPauseMusic()
            } else {
                playerManager.playNow([track])
            }
        }
    }
}

struct OverlayView: View {
    
    let imageName: String
    let playSize: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.black)
                .opacity(0.4)
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 50, maxHeight: 50)
                .frame(width: playSize, height: playSize)
                .foregroundColor(.white)
                .opacity(0.7)
        }
    }
}


//struct TrackOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        HoveringView()
//    }
//}
