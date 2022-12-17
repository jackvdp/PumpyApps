//
//  MenuTrack.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 24/08/2022.
//

import SwiftUI

public struct MenuTrackView<T:TokenProtocol,
                            N:NowPlayingProtocol,
                            B:BlockedTracksProtocol,
                            P:PlaylistProtocol,
                            H:HomeProtocol>: View {
    
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var tokenManager: T
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var homeVM: H
    @EnvironmentObject var alarmManager: AlarmManager
    private let size: CGFloat = 55
    private let cornerRadius: CGFloat = 10
    
    public init() {}
    
    public var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            if let track = nowPlayingManager.currentTrack {
                trackDetails(track)
            } else {
                noTrack
            }
        }
        .frame(height: size)
        .padding(12)
        .background(backgroundView)
        .overlay(overlayView)
        .cornerRadius(cornerRadius)
        .onTapGesture {
            homeVM.showPlayer = true
        }
    }
    
    var backgroundView: some View {
        ZStack {
            LinearGradient(colors: [Color.pumpyPurple, Color.pumpyBlue], startPoint: .top, endPoint: .bottom)
            artwork.background
        }
        .layoutPriority(1)
    }
    
    var overlayView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(Color.white.opacity(0.3), lineWidth: 1)
    }
    
    // MARK: No track view
    
    @ViewBuilder
    var noTrack: some View {
        Text("Not Playing...")
            .opacity(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
        playButton
    }
    
    var playButton: some View {
        Button {
            homeVM.coldStart(alarmData: alarmManager,
                             playlistManager: playlistManager)
        } label: {
            Image(systemName: "play.fill")
        }
        .buttonStyle(.plain)
        .font(.title)
        .padding()
    }
    
    // MARK: Track view
    
    @ViewBuilder
    func trackDetails(_ track: ConstructedTrack) -> some View {
        artwork
        songDetails(track)
        Spacer()
        dislikeButton(track: track)
    }

    var artwork: ArtworkView {
        let url = nowPlayingManager.currentTrack?.artworkURL
        return ArtworkView(artworkURL: url, size: size)
    }
        
    func songDetails(_ track: ConstructedTrack) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10.0) {
                Text(track.title ?? "N/A")
                    .font(.headline)
                    .lineLimit(1)
                if track.isExplicitItem {
                    Image(systemName: "e.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12, alignment: .center)
                }
            }
            Text(track.artist ?? "N/A")
                .font(.subheadline)
                .lineLimit(1)
            if playlistManager.playlistLabel != "" {
                Text(playlistManager.playlistLabel)
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
    }
    
    func dislikeButton(track: Track) -> some View {
        DislikeButton<N,B>(track: track, size: 20)
            .padding(.horizontal)
    }
}

#if DEBUG
struct MenuTrack_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            trackView
                .environmentObject(np)
                .environmentObject(MockPlaylistManager())
                .previewDisplayName("W/o playlist")
            trackView
                .environmentObject(np)
                .environmentObject(pm)
                .previewDisplayName("W/ playlist")
            trackView
                .environmentObject(MockNowPlayingManager())
                .environmentObject(MockPlaylistManager())
                .previewDisplayName("Not playing")
        }
        .preferredColorScheme(.dark)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.indigo)
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockTokenManager())
        .environmentObject(MockHomeVM())
        .environmentObject(AlarmManager())
    }
    
    static var np: MockNowPlayingManager {
        let now = MockNowPlayingManager()
        now.currentTrack = MockData.track
        return now
    }
    
    static var pm: MockPlaylistManager {
        let p = MockPlaylistManager()
        p.playlistLabel = "A Bit of Lunch"
        return p
    }
    
    static var trackView = MenuTrackView<MockTokenManager,
                                         MockNowPlayingManager,
                                         MockBlockedTracks,
                                         MockPlaylistManager,
                                         MockHomeVM>()
}
#endif
