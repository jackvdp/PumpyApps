//
//  ReusableGridView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 27/03/2022.
//

import SwiftUI
import PumpyAnalytics

struct ReusableGridView<G: GridViewModel>: View {
    
    @ObservedObject var gridVM: G
    let playlists: [PlaylistSnapshot]
    
    let columns = [
        GridItem(.adaptive(minimum: 182))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(playlists, id: \.self) { playlist in
                    ItemView(playlist: playlist, gridVM: gridVM)
                }
            }
            .padding(.horizontal)
        }
        
    }
}

struct GridsView_Previews: PreviewProvider {
    
    static let gridVM = SearchGridViewModel(navigator: SearchNavigationManager())
    
    static var previews: some View {
        ProviderView(label: "Apple Music:",
                     libraryPlaylists: [],
                    isSearching: true,
                    gridVM: gridVM)
            .frame(width: 800, height: 400)
        ProviderView(label: "Spotify:",
                    libraryPlaylists: [],
                    isSearching: false,
                    gridVM: gridVM)
            .frame(width: 800, height: 400)
        ProviderView(label: "Youtube:",
                    libraryPlaylists: MockData.snapshots,
                    isSearching: false,
                    gridVM: gridVM)
            .frame(width: 800, height: 400)
            .environmentObject(CreateManager())
            .environmentObject(SavedPlaylistController())
    }
}
