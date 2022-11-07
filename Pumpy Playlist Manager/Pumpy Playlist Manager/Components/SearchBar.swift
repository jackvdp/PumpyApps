//
//  SearchBar.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct SearchBar<ViewModel: SearchViewModel>: View {
    
    @ObservedObject var searchVM: ViewModel
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                TextField(
                    searchVM.placeHolderText,
                    text: $searchVM.searchTerm
                ).onSubmit {
                        searchVM.runSearch()
                    }
                if searchVM.searchTerm != "" {
                    Image(systemName: "x.circle.fill")
                        .frame(width: 5, height: 5)
                        .opacity(0.3)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            searchVM.searchTerm = ""
                        }
                }
            }
            .textFieldStyle(.roundedBorder)
            Button {
                searchVM.runSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
            }
            .frame(width: 15, height: 15)
            .foregroundColor(.pumpyPink)
            .buttonStyle(.plain)
        }
        .frame(idealWidth: 300)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var playlistVM: PlaylistFindViewModel {
        let playlistVM = PlaylistFindViewModel()
        playlistVM.searchTerm = "www.google.com/playlist/apple/playlist"
        return playlistVM
    }
    
    static var previews: some View {
        SearchBar(searchVM: playlistVM)
            .frame(width: 400)
        SearchBar(searchVM: playlistVM)
            .preferredColorScheme(.dark)
            .frame(width: 400)
    }
    
    
}
