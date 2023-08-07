//
//  ItemDetailView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 13/09/2022.
//

import SwiftUI
import PumpyAnalytics

struct ItemDetailView<P:PlaylistProtocol,
                      N:NowPlayingProtocol,
                      B:BlockedTracksProtocol,
                      Q:QueueProtocol>: View {
    
    @StateObject private var viewModel = ItemDetailViewModel()
    @EnvironmentObject var authManager: AuthorisationManager
    @Namespace var screen
    @State private var pageState: ItemDetailViewModel.PageState = .loading
    let snapshot: PlaylistSnapshot
    
    var body: some View {
        VStack {
            switch pageState {
            case .loading:
                ActivityView(activityIndicatorVisible: .constant(true)).noBackground
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
                    .id(screen)
            case .success(let playlist):
                successView(playlist)
            case .failed:
                failedView
            }
            
        }
        .pumpyBackground()
        .onAppear() {
            viewModel.getItem(snapshot: snapshot,
                              authManager: authManager)
        }
        .onChange(of: viewModel.pageState) { newValue in
            withAnimation {
                pageState = newValue
            }
        }
    }
    
    var failedView: some View {
        Button("Error occurred. Please try again.") {
            viewModel.pageState = .loading
        }
        .buttonStyle(.bordered)
        .foregroundColor(.gray)
    }
    
    @ViewBuilder
    func successView(_ playlist: PumpyAnalytics.Playlist) -> some View {
        if let plist = playlist as? Playlist {
            PlaylistView<P,N,B,Q>(playlist: plist)
                .transition(.opacity)
                .id(screen)
        } else {
            failedView
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    
    static let snapshot = PlaylistSnapshot(sourceID: "1234", type: .am(id: "1234"))
    
    static var previews: some View {
        ItemDetailView<MockPlaylistManager,
                       MockNowPlayingManager,
                       MockBlockedTracks,
                       MockQueueManager>(snapshot: snapshot).failedView
            .preferredColorScheme(.dark)
    }
}
