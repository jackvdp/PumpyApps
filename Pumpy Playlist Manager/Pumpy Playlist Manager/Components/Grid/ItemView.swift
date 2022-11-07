//
//  LibraryItemView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct ItemView<G: GridViewModel>: View {
    
    let playlist: PlaylistSnapshot
    @ObservedObject var gridVM: G
    var itemSize = 150
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: playlist.artworkURL?.getArtworkURLForSize(itemSize) ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(K.Images.pumpyArtwork)
                    .resizable()
            }
            .cornerRadius(5)
            .frame(width: CGFloat(itemSize), height: CGFloat(itemSize))
            Text(playlist.name ?? "N/A")
                .lineLimit(1)
            Text(playlist.shortDescription ?? "")
                .lineLimit(2)
                .opacity(0.5)
        }
        .frame(width: CGFloat(itemSize), height: CGFloat(itemSize + 55), alignment: .top)
        .padding()
        .buttonStyle(.plain)
        .gesture(TapGesture(count: 2).onEnded {
            gridVM.goToPlaylistView()
        })
        .simultaneousGesture(TapGesture().onEnded {
            gridVM.toggleSelectItem(playlist: playlist)
        })
        .background(
            Rectangle()
                .foregroundColor(gridVM.itemsSelected.contains(playlist) ? .pumpyPink : .clear)
                .cornerRadius(20)
        )
        .contextMenu {
            PlaylistContexMenu(playlist: playlist)
        }
    }
}

struct LibraryItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(playlist: MockData.snapshot, gridVM: LibrariesGridViewModel(navigator: LibrariesNavigationManager()))
    }
}
