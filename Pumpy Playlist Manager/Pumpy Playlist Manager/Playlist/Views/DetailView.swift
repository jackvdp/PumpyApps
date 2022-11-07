//
//  DetailView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct DetailView: View {
    @ObservedObject var playlistVM: PlaylistViewModel
    @ObservedObject var observeVM: ObserveTracksViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(playlistVM.playlist.name ?? "Playlist")
                    .font(.title)
                    .lineLimit(1)
                Text("\(playlistVM.playlist.curator) – \(playlistVM.playlist.tracks.count) tracks")
                    .opacity(0.5)
                Spacer()
                ButtonsView(playlistVM: playlistVM,
                            observedVM: observeVM)
                Spacer()
                Text(playlistVM.playlist.description ?? "")
            }
            Spacer()
            AsyncImage(url: URL(string: playlistVM.playlist.artworkURL?.getArtworkURLForSize(150) ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(K.Images.pumpyArtwork)
                    .resizable()
            }
            .cornerRadius(10)
            .frame(width: 150, height: 150)
        }
        .frame(height: 150)
        .padding(.horizontal)
    }
}



struct DetailView_Previews: PreviewProvider {
    static let dbController = SavedPlaylistController()
    
    static var previews: some View {
        DetailView(playlistVM: PlaylistViewModel(MockData.playlist,
                                                 snapshot: MockData.snapshot,
                                                 controller: dbController),
                   observeVM: ObserveTracksViewModel(MockData.playlist))
            .environmentObject(PlayerManager())
            .environmentObject(dbController)
    }
}
