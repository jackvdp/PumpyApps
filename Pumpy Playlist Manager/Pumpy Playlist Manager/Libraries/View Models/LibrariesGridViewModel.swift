//
//  HomeGridViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/04/2022.
//

import Foundation
import PumpyAnalytics

class LibrariesGridViewModel: GridViewModel, ObservableObject {

    @Published var itemsSelected = [PlaylistSnapshot]()
    @Published var displayedPlaylists = [PlaylistSnapshot]()
    let navigator: LibrariesNavigationManager
    
    init(navigator: LibrariesNavigationManager) {
        self.navigator = navigator
    }
    
    func toggleSelectItem(playlist: PlaylistSnapshot) {
        if itemsSelected.contains(playlist) {
            unSelectItem(playlist: playlist)
        } else {
            selectItem(playlist: playlist)
        }
    }
    
    func selectItem(playlist: PlaylistSnapshot) {
        itemsSelected = [playlist]
    }
    
    func unSelectItem(playlist: PlaylistSnapshot) {
        itemsSelected = [playlist]
    }
    
    func unSelectAllItems() {
        itemsSelected = []
    }
    
    func goToPlaylistView() {
        if let playlist = itemsSelected.first {
            navigator.currentPage = .playlist(playlist)
        }
    }
    
}
