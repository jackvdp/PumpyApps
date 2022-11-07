//
//  LibraryGridView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct SavedGridView: View {
    
    @EnvironmentObject var savedManager: SavedPlaylistController
    @ObservedObject var gridVM: SavedGridViewModel
    @StateObject var searchVM = PlaylistFindViewModel()
    @State private var showingPopover = false
    
    init(navigator: SavedNavigationManager) {
        gridVM = SavedGridViewModel(navigator: navigator)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if savedManager.savedPlaylists.isEmpty {
                Text("No playlists saved")
                    .font(.title)
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ReusableGridView(gridVM: gridVM, playlists: savedManager.savedPlaylists)
                .onTapGesture {
                    gridVM.unSelectAllItems()
                }
            }
            Button("Add") {
                showingPopover.toggle()
            }
            .buttonStyle(GrowingButton())
            .padding()
            .popover(isPresented: $showingPopover) {
                SearchBar(searchVM: searchVM)
                    .padding()
            }
        }
        .onChange(of: searchVM.libraryPlaylist) { newValue in
            guard let newValue = newValue else { return }
            gridVM.selectItem(playlist: newValue)
            gridVM.goToPlaylistView()
            
        }
        
    }
}

struct LibraryGridView_Previews: PreviewProvider {
    static let libMan = SavedPlaylistController()
    
    static var previews: some View {
        SavedGridView(navigator: SavedNavigationManager())
            .environmentObject(PlayerManager())
            .environmentObject(AuthorisationManager())
            .environmentObject(libMan)
            .frame(width: 1300, height: 800)
            .onAppear {
                libMan.savedPlaylists = []
            }
        SavedGridView(navigator: SavedNavigationManager())
            .environmentObject(PlayerManager())
            .environmentObject(AuthorisationManager())
            .environmentObject(SavedPlaylistController())
            .frame(width: 1300, height: 800)
    }
}
