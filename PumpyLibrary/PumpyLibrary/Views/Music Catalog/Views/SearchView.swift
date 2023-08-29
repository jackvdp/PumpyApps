//
//  CatalogSearchView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 14/09/2022.
//

import SwiftUI
import PumpyAnalytics
import PumpyShared

struct SearchView<
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
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
            case .success(am: let am,
                          spotify: let spot,
                          syb: let syb,
                          artistStations: let stations,
                          tracks: let tracks):
                searchResults(
                    amPlaylists: am,
                    spotPlaylists: spot,
                    sybPlaylists: syb,
                    artistStations: stations,
                    tracks: tracks
                )
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
    
    // MARK: Search Results View
    
    func searchResults(amPlaylists: [PlaylistSnapshot],
                       spotPlaylists: [PlaylistSnapshot],
                       sybPlaylists: [PlaylistSnapshot],
                       artistStations: [PlaylistSnapshot],
                       tracks: [Track]) -> some View {
        ScrollView {
            filterButtons(
                hasAmPlaylists: amPlaylists.isNotEmpty,
                hasSpotPlaylists: spotPlaylists.isNotEmpty,
                hasSybPlaylists: sybPlaylists.isNotEmpty,
                hasArtistStations: artistStations.isNotEmpty,
                hasTracks: tracks.isNotEmpty
            )
            if sybPlaylists.isNotEmpty &&
                (filterSearch == .syb || filterSearch == nil) {
                titleAndGrid(text: "Pumpy Playlists",
                             playlists: sybPlaylists)
            }
            if amPlaylists.isNotEmpty &&
                (filterSearch == .am || filterSearch == nil) {
                titleAndGrid(text: "Apple Music Playlists",
                             playlists: amPlaylists)
            }
            if spotPlaylists.isNotEmpty &&
                (filterSearch == .spotify || filterSearch == nil) {
                titleAndGrid(text: "Spotify Playlists",
                             playlists: spotPlaylists)
            }
            if artistStations.isNotEmpty &&
                (filterSearch == .artist || filterSearch == nil) {
                titleAndGrid(text: "Artist Stations",
                             playlists: artistStations)
            }
            if tracks.isNotEmpty &&
                (filterSearch == .tracks || filterSearch == nil) {
                title("Tracks")
                tracksList(tracks)  
            }
            if amPlaylists.isEmpty &&
                spotPlaylists.isEmpty &&
                sybPlaylists.isEmpty &&
                artistStations.isEmpty &&
                tracks.isEmpty {
                emptySearch
            }
        }
    }
    
    func titleAndGrid(
        text: String,
        playlists: [PlaylistSnapshot]
    ) -> some View {
        VStack {
            title(text)
            PlaylistGrid<P,N,B,Q>(playlists: playlists)
        }
    }
    
    func tracksList(_ tracks: [Track]) -> some View {
        ForEach(tracks.indices, id: \.self) { i in
            TrackRow<N,B,P,Q>(track: tracks[i], authManager: authManager,
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
    
    // MARK: Filter Buttons
    
    enum FilterSearch: Equatable {
        case am, syb, spotify, artist, tracks
    }
    @State var filterSearch: FilterSearch?
    
    @ViewBuilder
    func filterButtons(hasAmPlaylists: Bool,
                       hasSpotPlaylists: Bool,
                       hasSybPlaylists: Bool,
                       hasArtistStations: Bool,
                       hasTracks: Bool) -> some View {
        if !hasAmPlaylists &&
            !hasSpotPlaylists &&
            !hasSybPlaylists &&
            !hasArtistStations &&
            !hasTracks {
            EmptyView()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if hasSybPlaylists {
                        capsule("Pumpy",
                                selected: filterSearch == .syb) {
                            if filterSearch == .syb { filterSearch = nil } else {
                                filterSearch = .syb
                            }
                        }
                    }
                    if hasAmPlaylists {
                        capsule("Apple Music",
                                selected: filterSearch == .am) {
                            if filterSearch == .am { filterSearch = nil } else {
                                filterSearch = .am
                            }
                        }
                    }
                    if hasSpotPlaylists {
                        capsule("Spotify",
                                selected: filterSearch == .spotify) {
                            if filterSearch == .spotify { filterSearch = nil } else {
                                filterSearch = .spotify
                            }
                        }
                    }
                    if hasArtistStations {
                        capsule("Artists",
                                selected: filterSearch == .artist) {
                            if filterSearch == .artist { filterSearch = nil } else {
                                filterSearch = .artist
                            }
                        }
                    }
                    if hasTracks {
                        capsule("Tracks",
                                selected: filterSearch == .tracks) {
                            if filterSearch == .tracks { filterSearch = nil } else {
                                filterSearch = .tracks
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func capsule(_ title: String,
                 selected: Bool,
                 action: @escaping () -> ()) -> some View {
        Button {
            withAnimation { action() }
        } label: {
            Text(title)
                .foregroundColor(.white.opacity(0.85))
                .font(.subheadline)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.pumpyPink.opacity(selected ? 1 : 0.5))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .buttonStyle(.plain)
    }
    
    // MARK: Empty/Failed/Loading View
    
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
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Methods
    
    func playFromPosition(tracks: [Track], index: Int) {
        let playlist = QueuePlaylist(title: viewModel.searchText,
                                     curator: "",
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
        MockQueueManager
    >()
    
    static var previews: some View {
        Group {
            searchView.searchResults(
                amPlaylists: snapshots,
                spotPlaylists: snapshots,
                sybPlaylists: snapshots,
                artistStations: snapshots,
                tracks: tracks
            )
            PumpyList {
                searchView.searchResults(
                    amPlaylists: [],
                    spotPlaylists: [],
                    sybPlaylists: [],
                    artistStations: [],
                    tracks: []
                )
            }
            PumpyList {
                searchView.loadingView
            }
            PumpyList {
                searchView.failedView
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    searchView.capsule("Apple Music", selected: true, action: {})
                    searchView.capsule("Spotify", selected: false, action: {})
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .pumpyBackground()
            .preferredColorScheme(.dark)
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
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
