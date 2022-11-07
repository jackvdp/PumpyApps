//
//  SearchPlaylistsView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/05/2022.
//

import SwiftUI
import PumpyAnalytics

struct SearchProvidersView: View {
    
    @ObservedObject var searchVM: SearchResultsViewModel
    @StateObject var gridVM: SearchGridViewModel
    
    init(searchVM: SearchResultsViewModel, navigator: SearchNavigationManager) {
        _gridVM = StateObject(wrappedValue: SearchGridViewModel(navigator: navigator))
        self.searchVM = searchVM
    }
    
    var body: some View {
        ScrollView {
            ProviderView(label: "Apple Music:",
                        libraryPlaylists: searchVM.amPLaylists,
                        isSearching: searchVM.amSearching,
                        gridVM:  gridVM)
            ProviderView(label: "Spotify:",
                        libraryPlaylists: searchVM.spotifyPLaylists,
                        isSearching: searchVM.spotifySearching,
                        gridVM:  gridVM)
            ProviderView(label: "SoundTrackYourBrand:",
                        libraryPlaylists: searchVM.sybPLaylists,
                        isSearching: searchVM.sybSearching,
                        gridVM:  gridVM)
            if let artist = searchVM.artistStation {
                ProviderView(label: "Artist Station:",
                            libraryPlaylists: [artist],
                            isSearching: searchVM.artistStationSearching,
                            gridVM:  gridVM)
            }
        }
    }
}

struct SearchPlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchProvidersView(searchVM: SearchResultsViewModel(), navigator: SearchNavigationManager())
    }
}
