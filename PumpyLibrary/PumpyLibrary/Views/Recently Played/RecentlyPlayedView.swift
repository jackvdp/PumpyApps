//
//  RecntlyPlayedView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 07/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct RecentlyPlayedView<
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
    @EnvironmentObject var recentlyPlayedManager: RecentlyPlayedManager
    
    var body: some View {
        if !recentlyPlayedManager.items.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                title.padding(.horizontal, 20).padding(.bottom)
                PlaylistGrid<P,N,B,Q>(playlists: snaposhots, oneRow: true)
            }
            .padding(.top)
        }
    }
    
    var title: some View {
        Text("Jump back in")
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var snaposhots: [PlaylistSnapshot] {
        return recentlyPlayedManager.items.compactMap { item in
            switch item {
            case .playlist(let snapshot):
                return snapshot
            default:
                return nil
            }
        }
    }
}

struct RecntlyPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyPlayedView<
        MockPlaylistManager,
        MockNowPlayingManager,
        MockBlockedTracks,
        MockQueueManager
        >().environmentObject(RecentlyPlayedManager())
    }
}
