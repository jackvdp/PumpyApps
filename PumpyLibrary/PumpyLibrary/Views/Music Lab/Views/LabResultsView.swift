//
//  LabResultsView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 02/04/2023.
//

import SwiftUI
import PumpyAnalytics

struct LabResultView<P:PlaylistProtocol,
                     N:NowPlayingProtocol,
                     B:BlockedTracksProtocol,
                     T:TokenProtocol,
                     Q:QueueProtocol>: View {
    
    @EnvironmentObject var labManager: MusicLabManager
    @EnvironmentObject var authManager: AuthorisationManager
    @State private var pageState: PageState = .loading
    
    var body: some View {
        Group {
            switch pageState {
            case .loading:
                ActivityView(activityIndicatorVisible: .constant(true)).noBackground
            case .playlist(let playlist):
                TrackTable<P,N,B,T,Q>(playlist: playlist)
            case .error:
                Text("Error.\nPlease try again")
            }
        }
        .pumpyBackground()
        .onAppear {
            labManager.createMix(authManager: authManager) { playlist in
                withAnimation {
                    if let playlist { pageState = .playlist(playlist) } else {
                        pageState = .error
                    }
                }
            }
        }
    }
    
    enum PageState { case loading, playlist(RecommendedPlaylist), error }
}
