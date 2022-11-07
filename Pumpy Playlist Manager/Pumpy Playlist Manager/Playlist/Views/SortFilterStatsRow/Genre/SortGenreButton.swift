//
//  SortGenreButton.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 04/05/2022.
//

import SwiftUI
import PumpyAnalytics

struct SortGenreButton: View {
    @ObservedObject var playlistVM: FilterableViewModel
    @State private var showGenresFilter = false
    
    var body: some View {
        Button {
            playlistVM.getGenres()
            showGenresFilter.toggle()
        } label: {
            Image(systemName: "music.mic")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.pumpyPink)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showGenresFilter) {
            SortGenreView(playlistVM: playlistVM)
        }
    }
    
}

struct SortGenreButton_Previews: PreviewProvider {
    static var previews: some View {
        SortGenreButton(
            playlistVM: PlaylistViewModel(
            MockData.playlist,
            snapshot: MockData.snapshot,
            controller: SavedPlaylistController()))
    }
}

extension Color {
    static let pumpyPink = Color("pumpyPink")
    static let pumpyPinkDark = Color("pumpyPink-dark")
}
