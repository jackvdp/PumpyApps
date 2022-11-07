//
//  PlayerContent.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct PlayerContent: View {
    
    @ObservedObject var playerManager: PlayerManager
    @State private var showStats = false
    @Namespace var songID
    
    var body: some View {
        HStack {
            track
            Spacer()
            buttons
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    var track: some View {
        HStack {
            artwork
            trackDetails
        }
        .contextMenu {
            if let track = playerManager.currentTrack {
                TrackContextMenu(tracks: [], currentTrack: track)
            }
        }
    }
    
    var artwork: some View {
        AsyncImage(
            url: URL(string: playerManager.currentTrack?.artworkURL?.getArtworkURLForSize(75) ?? ""),
            transaction: Transaction(animation: .default)
        ) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
            default:
                Image(K.Images.pumpyArtwork)
                    .resizable()
            }
        }
        .cornerRadius(5)
        .frame(width: 75, height: 75)
    }
    
    var trackDetails: some View {
        VStack(alignment: .leading) {
            Text(playerManager.currentTrack?.title ?? "*Not Playling*")
            Text(playerManager.currentTrack?.artist ?? "")
            if let playlist = playerManager.playlistPlaying {
                Text("Playing from *\(playlist)*")
                    .font(.subheadline)
            }
        }
    }
    
    var buttons: some View {
        HStack(spacing: 25) {
            Image(systemName: "chart.bar.xaxis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 15)
                .opacity(playerManager.currentTrack == nil ? 0.5 : 1)
                .onTapGesture {
                    if playerManager.currentTrack != nil {
                        showStats.toggle()
                    }
                }
                .popover(isPresented: $showStats) {
                    if let track = playerManager.currentTrack {
                        TrackStatsView(track: track)
                    }
                }
            Image(systemName: playerManager.playerState == .playing ? "pause.fill" : "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .opacity(playerManager.currentTrack == nil ? 0.5 : 1)
                .onTapGesture {
                    playerManager.playPauseMusic()
                }
            Image(systemName: "forward.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 20)
                .opacity(playerManager.currentTrack == nil ? 0.5 : 1)
                .onTapGesture {
                    playerManager.nextTrack()
                }
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 15, height: 15)
                .opacity(0.5)
                .onTapGesture {
                    playerManager.quitPlayer()
                }
        }
    }
}

struct PlayerContent_Previews: PreviewProvider {
    static var playerManager: PlayerManager {
        let pm = PlayerManager()
        pm.currentTrack = MockData.track
        pm.playlistPlaying = "A Bit of Lunch"
        return pm
    }
    
    static var previews: some View {
        PlayerContent(playerManager: playerManager)
            .environmentObject(CreateManager())
            .environmentObject(playerManager)
        PlayerContent(playerManager: PlayerManager())
        
    }
}
