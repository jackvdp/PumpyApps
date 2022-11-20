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
    
    @ObservedObject var viewModel: CatalogSearchViewModel
    @EnvironmentObject var authManager: AuthorisationManager
    @State private var pageState: CatalogSearchViewModel.PageState = .loading
    let playlistRows: [GridItem] = Array(repeating: GridItem(.fixed(200)), count: 2)
    @Namespace var screen
    
    var body: some View {
        VStack {
            switch pageState {
            case .loading:
                ActivityView(activityIndicatorVisible: .constant(true))
                    .transition(.opacity)
                    .id(screen)
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
    
    func searchResults(_ playlists: [PlaylistSnapshot],
                       _ tracks: [Track]) -> some View {
        ScrollView {
            Group {
                if playlists.isNotEmpty {
                    title("Playlists")
                        .padding(.vertical)
                        .padding(.top, 6)
                    playlistGrids(playlists)
                        .padding(.horizontal, -20)
                }
                if tracks.isNotEmpty {
                    title("Tracks")
                        .padding(.vertical)
                    tracksList(tracks)
                }
                if playlists.isEmpty && tracks.isEmpty {
                    Text("*No Results*\nTry a new search")
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
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
            .padding(.horizontal)
        }
    }
    
    func tracksList(_ tracks: [Track]) -> some View {
        ForEach(tracks.indices, id: \.self) { i in
            TrackRow<T,N,B,P,Q>(track: tracks[i])
            Divider()
        }
    }
    
    func title(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2.bold())
            Divider()
        }
        
    }
    
    var failedView: some View {
        Button("Error occurred. Please try again.") {
            viewModel.searchAgain(authManager: authManager)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.gray)
    }
    
}

struct CatalogSearchView_Previews: PreviewProvider {
    
    static var searchView = CatalogSearchView<MockHomeVM,
                                   MockPlaylistManager,
                                   MockNowPlayingManager,
                                   MockBlockedTracks,
                                   MockTokenManager,
                                   MockQueueManager>(viewModel: CatalogSearchViewModel())
    
    static var previews: some View {
        PumpyList {
            Text(snapshots.count.description)
            searchView.searchResults(snapshots, tracks)
//                .border(.green)
        }
        .listStyle(.plain)
        .border(.indigo)
            .preferredColorScheme(.dark)
            .environmentObject(MockTokenManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockBlockedTracks())
    }

    static var snapshots: [PlaylistSnapshot] {
        PumpyAnalytics.MockData.snapshots
    }
    
    static var tracks: [Track] {
        MockData.tracks
    }
}
