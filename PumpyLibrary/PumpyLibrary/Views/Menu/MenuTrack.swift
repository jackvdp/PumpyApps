//
//  MenuTrack.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 24/08/2022.
//

import SwiftUI
import PumpyAnalytics

public struct MenuTrackView<
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    P:PlaylistProtocol,
    H:HomeProtocol
>: View {
    
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var tokenManager: AuthorisationManager
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var homeVM: H
    @EnvironmentObject var alarmManager: AlarmManager
    private let size: CGFloat = 50
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
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
        .padding(.vertical, 12)
        .padding(.horizontal)
        .padding(.bottom, safeAreaInsets.bottom / 2)
        .playerBackground()
        .onTapGesture {
            homeVM.showPlayer = true
        }
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
        .font(.title2)
        .padding(8)
    }
    
    // MARK: Track view
    
    @ViewBuilder
    func trackDetails(_ track: Track) -> some View {
        artwork
        songDetails(track)
        Spacer()
        playerControls
    }
    
    var artwork: ArtworkView {
        ArtworkView(
            collection: nowPlayingManager.currentTrack,
            setBackground: true,
            size: size
        )
    }
        
    func songDetails(_ track: Track) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10.0) {
                Text(track.name)
                    .font(.callout).bold()
                    .lineLimit(1)
                if track.isExplicitItem {
                    Image(systemName: "e.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12, alignment: .center)
                }
            }
            Text(track.artistName)
                .font(.footnote)
                .lineLimit(1)
            if playlistManager.playlistLabel != "" {
                Text(playlistManager.playlistLabel)
                    .font(.footnote)
                    .lineLimit(1)
            }
        }
    }
    
    @ViewBuilder
    var playerControls: some View {
        Button {
            homeVM.playPause(alarmData: alarmManager,
                             playlistManager: playlistManager)
        } label: {
            Image(systemName: nowPlayingManager.playButtonState == .playing ? "pause.fill" : "play.fill")
        }
        .buttonStyle(.plain)
        .font(.title2)
        .padding(.leading, 8)
        Button {
            homeVM.skipToNextItem()
        } label: {
            Image(systemName: "forward.fill")
        }
        .buttonStyle(.plain)
        .font(.title2)
        .padding(8)
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
    
    static var trackView = MenuTrackView<MockNowPlayingManager,
                                         MockBlockedTracks,
                                         MockPlaylistManager,
                                         MockHomeVM>()
}
#endif
