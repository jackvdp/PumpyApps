//
//  ReusableRowView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/05/2022.
//

import SwiftUI
import PumpyAnalytics

struct ReusableRowView<G: GridViewModel>: View {
    
    @ObservedObject var gridVM: G
    let playlists: [PlaylistSnapshot]
    let rows: [GridItem]
    
    init(gridVM: G, playlists: [PlaylistSnapshot]) {
        self.gridVM = gridVM
        self.playlists = playlists
        rows = [GridItem](repeating: GridItem(.fixed(230)),
                          count: playlists.count == 1 ? 1 : 2)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Spacer()
                    .frame(width: 24)
                LazyHGrid(rows: rows, spacing: 24) {
                    ForEach(playlists, id: \.self) { playlist in
                        ItemView(playlist: playlist, gridVM: gridVM)
                    }
                }
            }
        }
    }
}

struct ReusableRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableRowView(gridVM: SavedGridViewModel(navigator: SavedNavigationManager()),
                        playlists: MockData.snapshots)
            .frame(width: 1300, height: 800)
            .environmentObject(CreateManager())
            .environmentObject(SavedPlaylistController())
    }
}
