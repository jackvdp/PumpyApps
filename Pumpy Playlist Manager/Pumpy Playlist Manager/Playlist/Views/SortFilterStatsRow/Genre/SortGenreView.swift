//
//  SortGenreView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 26/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct SortGenreView: View {
    
    @ObservedObject var playlistVM: FilterableViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Genres")
                .font(.title3.weight(.bold))
            Divider()
            genreList
            Divider()
            buttons
        }
        .padding()
        .onAppear {
            playlistVM.getGenres()
        }
    }
    
    var genreList: some View {
        ScrollView {
            ForEach(playlistVM.genres, id: \.self) { genre in
                HStack {
                    GenreCheckbox(playlistVM: playlistVM,
                                  genreCheckbox: !playlistVM.unwantedGenres.contains(genre),
                                  genre: genre)
                    Spacer()
                }
            }
        }
    }
    
    var buttons: some View {
        HStack {
            Button("Select All") {
                playlistVM.unwantedGenres = []
            }
            .buttonStyle(.link)
            .font(.callout)
            Spacer(minLength: 25)
            Button("Unselect All") {
                playlistVM.unwantedGenres = playlistVM.genres
            }
            .buttonStyle(.link)
            .font(.callout)
        }
        .foregroundColor(.pumpyPink)
    }
}

struct SortGenreView_Previews: PreviewProvider {
    
    static var playlistVM: PlaylistViewModel {
        let pVM = PlaylistViewModel(MockData.playlist,
                                    snapshot: MockData.snapshot,
                                    controller: SavedPlaylistController())
        pVM.genres = ["Pop", "Rock", "Dance", "Alternative", "R&B", "Hip-Hop", "Electronic"]
        pVM.unwantedGenres = ["Dance", "Alternative"]
        
        return pVM
    }
    
    static var previews: some View {
        SortGenreView(playlistVM: playlistVM)
            .frame(width: 200)
    }
}

struct GenreCheckbox: View {
    
    @ObservedObject var playlistVM: FilterableViewModel
    @State var genreCheckbox: Bool
    let genre: String?
    
    var body: some View {
        Toggle(genre ?? "-", isOn: $genreCheckbox)
            .toggleStyle(.checkbox)
            .onChange(of: genreCheckbox) { checked in
                if checked {
                    playlistVM.unwantedGenres.removeAll { $0 == genre }
                } else {
                    playlistVM.unwantedGenres.append(genre)
                }
            }
            .onChange(of: playlistVM.unwantedGenres) { newUnwantedGenres in
                genreCheckbox = !newUnwantedGenres.contains(genre)
            }
    }
    
}
