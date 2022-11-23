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
    @EnvironmentObject var playlistManager: P
    @State private var pageState: CatalogSearchViewModel.PageState = .loading
    @Namespace var screen
    
    var body: some View {
        VStack {
            switch pageState {
            case .loading:
                loadingView
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
    
    // Components
    
    func searchResults(_ playlists: [PlaylistSnapshot],
                       _ tracks: [Track]) -> some View {
        ScrollView {
            Group {
                if playlists.isNotEmpty {
                    title("Playlists")
                    playlistGrids(playlists)
                }
                if tracks.isNotEmpty {
                    title("Tracks")
                    tracksList(tracks)
                }
                if playlists.isEmpty && tracks.isEmpty {
                    emptySearch
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
        }
        .padding(.horizontal, -20)
    }
    
    
    func playlistGrids(_ playlists: [PlaylistSnapshot]) -> some View {
        let playlistRows = Array(repeating: GridItem(.fixed(200)),
                                 count: playlists.count == 1 ? 1 : 2)
        
        return ScrollView(.horizontal) {
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
        .padding(.horizontal, -20)
    }
    
    func tracksList(_ tracks: [Track]) -> some View {
        ForEach(tracks.indices, id: \.self) { i in
            TrackRow<T,N,B,P,Q>(track: tracks[i])
                .onTapGesture {
                    playFromPosition(tracks: tracks, index: i)
                }
            Divider()
        }
    }
    
    func title(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2.bold())
            Divider()
        }.padding(.vertical)
    }
    
    var emptySearch: some View {
        Text("**No Results**\nTry a new search")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
            .padding(.vertical, 100)
            .opacity(0.5)
    }
    
    var failedView: some View {
        Button("Search Error.\n Please try again.") {
            viewModel.searchAgain(authManager: authManager)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 100)
    }
    
    var loadingView: some View {
        ActivityView(activityIndicatorVisible: .constant(true))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 100)
    }
    
    // Methods
    
    func playFromPosition(tracks: [Track], index: Int) {
        let playlist = ConstructedPlaylist(name: viewModel.lastSearchTerm,
                                           tracks: tracks,
                                           cloudGlobalID: nil,
                                           artworkURL: nil)
        playlistManager.playPlaylist(playlist: playlist, from: index)
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
        Group {
            PumpyList {
                searchView.searchResults(snapshots, tracks)
            }
            PumpyList {
                searchView.searchResults([], [])
            }
            PumpyList {
                searchView.loadingView
            }
            PumpyList {
                searchView.failedView
            }
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
        .environmentObject(MockTokenManager())
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockQueueManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockHomeVM())
        .environmentObject(AuthorisationManager())
    }

    static var snapshots: [PlaylistSnapshot] {
        PumpyAnalytics.MockData.snapshots
    }
    
    static var tracks: [Track] {
        MockData.tracks
    }
}
