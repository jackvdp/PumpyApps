//
//  CatalogSearchView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 14/09/2022.
//

import SwiftUI
import PumpyAnalytics

struct CatalogSearchView<H:HomeProtocol,
                         P:PlaylistProtocol,
                         N:NowPlayingProtocol,
                         B:BlockedTracksProtocol,
                         T:TokenProtocol,
                         Q:QueueProtocol>: View {
    
    let term: String
    
    @StateObject private var viewModel = CatalogSearchViewModel()
    @EnvironmentObject var authManager: AuthorisationManager
    @State private var pageState: CatalogSearchViewModel.PageState = .loading
    let playlistRows: [GridItem] = Array(repeating: GridItem(.fixed(150)), count: 2)
    @Namespace var screen
    
    var body: some View {
        VStack {
            switch pageState {
            case .loading:
                ActivityView(activityIndicatorVisible: .constant(true))
                    .transition(.opacity)
                    .id(screen)
                    .onAppear() {
                        viewModel.runSearch(term: term, authManager: authManager)
                    }
            case .success(let playlistSnapshots, let tracks):
                searchResults(playlistSnapshots, tracks)
                    .transition(.opacity)
                    .id(screen)
            case .failed:
                failedView
            }
        }
        .onChange(of: viewModel.pageState) { newValue in
            withAnimation {
                pageState = newValue
            }
        }
    }
    
    func searchResults(_ playlists: [PlaylistSnapshot],_ tracks: [Track]) -> some View {
        VStack(spacing: 0) {
            if playlists.isNotEmpty {
                title("Playlists")
                    .padding(.top, 6)
                playlistGrids(playlists)
            }
            if tracks.isNotEmpty {
                title("Tracks")
                tracksList(tracks)
            }
            if playlists.isEmpty && tracks.isEmpty {
                Text("*No Results*\nTry a new search")
            }
        }
    }
    
    func playlistGrids(_ playlists: [PlaylistSnapshot]) -> some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: playlistRows, alignment: .center, spacing: 20) {
                ForEach(playlists, id: \.sourceID) { item in
                    NavigationLink(destination: ItemDetailView<H,P,N,B,T,Q>(snapshot: item)) {
                        ItemGridComponent(name: item.name ?? "",
                                          curator: item.curator ?? "",
                                          itemArtworkURL: item.artworkURL ?? "",
                                          size: 200)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    func tracksList(_ tracks: [Track]) -> some View {
        List(tracks.indices, id: \.self) { i in
            TrackRow<T,N,B,P,Q>(track: tracks[i])
        }
    }
    
    func title(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2.bold())
            Divider()
        }
        .padding(.leading)
    }
    
    var failedView: some View {
        Button("Error occurred. Please try again.") {
            viewModel.runSearch(term: term, authManager: authManager)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.gray)
    }
    
}

struct CatalogSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogSearchView<MockHomeVM,
                          MockPlaylistManager,
                          MockNowPlayingManager,
                          MockBlockedTracks,
                          MockTokenManager,
                          MockQueueManager>(term: "Ed Sheeran")
            .preferredColorScheme(.dark)
            .environmentObject(AuthorisationManager())
    }
}
