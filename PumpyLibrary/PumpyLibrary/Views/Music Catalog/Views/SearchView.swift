//
//  CatalogSearchView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 14/09/2022.
//

import SwiftUI
import PumpyAnalytics

struct SearchView<P:PlaylistProtocol,
                  N:NowPlayingProtocol,
                  B:BlockedTracksProtocol,
                  T:TokenProtocol,
                  Q:QueueProtocol>: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var authManager: AuthorisationManager
    @EnvironmentObject var playlistManager: P
    @Namespace var screen
    
    var body: some View {
        Group {
            switch viewModel.pageState {
            case .searchStage:
                searchStageView
                    .transition(.opacity)
                    .id(screen)
            case .loading:
                loadingView
                    .transition(.opacity)
                    .id(screen)
            case .success(am: let am, spotify: let spot, syb: let syb, tracks: let tracks):
                searchResults(am, spot, syb, tracks)
                    .transition(.opacity)
                    .id(screen)
            case .failed:
                failedView
            }
        }
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Playlists, Artists, Songs")
        .pumpyBackground()
        .onSubmit(of: .search, runSearch)
        .onChange(of: viewModel.searchText, perform: handleSearchTextChanged)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Search")
    }
    
    // MARK: - Components
    
    func searchResults(_ amPlaylists: [PlaylistSnapshot],
                       _ spotPlaylists: [PlaylistSnapshot],
                       _ sybPlaylists: [PlaylistSnapshot],
                       _ tracks: [Track]) -> some View {
        ScrollView {
            if sybPlaylists.isNotEmpty {
                titleAndGrid(text: "Pumpy Playlists",
                             playlists: sybPlaylists)
            }
            if amPlaylists.isNotEmpty {
                titleAndGrid(text: "Apple Music Playlists",
                             playlists: amPlaylists)
            }
            if spotPlaylists.isNotEmpty {
                titleAndGrid(text: "Spotify Playlists",
                             playlists: spotPlaylists)
            }
            if tracks.isNotEmpty {
                title("Tracks")
                tracksList(tracks)  
            }
            if amPlaylists.isEmpty &&
                spotPlaylists.isEmpty &&
                sybPlaylists.isEmpty &&
                tracks.isEmpty {
                emptySearch
            }
        }
    }
    
    func titleAndGrid(text: String, playlists: [PlaylistSnapshot]) -> some View {
        VStack {
            title(text)
            playlistGrids(playlists)
        }
    }
    
    func playlistGrids(_ playlists: [PlaylistSnapshot]) -> some View {
        let playlistRows = Array(repeating: GridItem(.fixed(200)),
                                 count: playlists.count == 1 ? 1 : 2)
        
        return ScrollView(.horizontal) {
            LazyHGrid(rows: playlistRows, alignment: .center, spacing: 20) {
                ForEach(playlists, id: \.sourceID) { item in
                    NavigationLink(destination: ItemDetailView<P,N,B,T,Q>(snapshot: item)) {
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
            TrackRow<T,N,B,P,Q>(track: tracks[i],
                                tapAction: { playFromPosition(tracks: tracks, index: i) })
            .padding(.leading)
            Divider()
        }
    }
    
    func title(_ title: String) -> some View {
        Text(title)
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
    
    var emptySearch: some View {
        Text("**No Results**\nTry a new search")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
            .padding(.vertical, 100)
            .opacity(0.5)
            .pumpyBackground()
            .edgesIgnoringSafeArea(.all)
    }
    
    var failedView: some View {
        Button("Search Error.\n Please try again.") {
            viewModel.runSearch(authManager: authManager)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 100)
    }
    
    var loadingView: some View {
        ActivityView(activityIndicatorVisible: .constant(true)).noBackground
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: Search Suggestions
    
    @ViewBuilder
    var searchStageView: some View {
        if viewModel.searchSuggestions.isNotEmpty {
            // SEARCH SUGGESTIONS
            List {
                ForEach(viewModel.searchSuggestions, id: \.self) { suggestion in
                    searchRow(suggestion)
                }
                .listRowBackground(Color.primary.opacity(0.1))
            }
            .clearListBackgroundIOS16()
        } else {
            // RECENT SEARCHES
            List {
                if viewModel.recentSearches.isNotEmpty {
                    Text("RECENT SEARCHES").font(.callout).bold()
                        .listRowBackground(Color.clear)
                    ForEach(viewModel.recentSearches, id: \.self) { search in
                        searchRow(search)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
        }
    }
    
    func searchRow(_ item: String) -> some View {
        Button {
            viewModel.searchWithSuggestion(item, authManager: authManager)
        } label: {
            Label(item, systemImage: "magnifyingglass")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: Methods
    
    func playFromPosition(tracks: [Track], index: Int) {
        let playlist = QueuePlaylist(title: viewModel.searchText,
                                     songs: tracks,
                                     cloudGlobalID: nil,
                                     artworkURL: nil)
        playlistManager.playPlaylist(playlist: playlist, from: index)
    }
    
    func runSearch() {
        viewModel.runSearch(authManager: authManager)
    }
    
    func handleSearchTextChanged(_ text: String) {
        viewModel.getSuggestions(authManager: authManager)
        if !viewModel.searchTextChangedByCompletion {
            withAnimation {
                viewModel.pageState = .searchStage
            }
        } else {
            viewModel.searchTextChangedByCompletion = false
        }
    }
}

// MARK: - Previews

struct CatalogSearchView_Previews: PreviewProvider {
    
    static var searchView = SearchView<
        MockPlaylistManager,
        MockNowPlayingManager,
        MockBlockedTracks,
        MockTokenManager,
        MockQueueManager
    >()
    
    static var previews: some View {
        Group {
            searchView.searchResults(snapshots, snapshots, snapshots, tracks)
            PumpyList {
                searchView.searchResults([], [], [], [])
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
