//
//  SortSearchView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 16/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct SortSearchView: View {
    
    @ObservedObject var playlistVM: FilterableViewModel
    @StateObject var searchVM = TrackSearchViewModel()
    @ObservedObject var showColumns: ColumnsShowing
    @ObservedObject var observeVM: ObserveTracksViewModel
    
    var body: some View {
        HStack {
            SortMenuView(sortBy: $playlistVM.sortBy,
                         ascending: $playlistVM.ascending)
            Spacer()
            PlaylistStatsButton(playlistVM: playlistVM,
                                observeVM: observeVM)
                .padding(.horizontal)
            ShowColumnButton(showColumn: showColumns)
                .padding(.horizontal)
            SortGenreButton(playlistVM: playlistVM)
                .padding(.horizontal)
            SearchBar(searchVM: searchVM)
                .frame(width: 250)
        }
        .onChange(of: searchVM.searchTerm) { newValue in
            playlistVM.searchTerm = newValue
        }
    }
}

struct SortSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SortSearchView(playlistVM:
                        PlaylistViewModel(
                            MockData.playlist,
                            snapshot: MockData.snapshot,
                            controller: SavedPlaylistController()),
                       showColumns: ColumnsShowing(),
                       observeVM: ObserveTracksViewModel(MockData.playlist))
            .frame(width: 800)
    }
}
