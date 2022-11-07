//
//  SearchPlaylistsView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 29/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct ProviderView<G: GridViewModel>: View {
    
    var label: String
    var libraryPlaylists: [PlaylistSnapshot]
    var isSearching: Bool
    var gridVM: G
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.title3.weight(.semibold))
                    .padding([.horizontal, .top])
                if isSearching {
                    AppActivityIndicatorView(isVisible: .constant(true))
                        .frame(maxWidth: .infinity)
                } else {
                    if libraryPlaylists.isEmpty {
                        Text("No playlists found")
                            .font(.title)
                            .opacity(0.5)
                            .padding()
                            .frame(maxWidth: .infinity)
                    } else {
                        ReusableRowView(gridVM: gridVM, playlists: libraryPlaylists)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SearchProviderView_Previews: PreviewProvider {
    
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
