//
//  SearchGridViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 29/04/2022.
//

import Foundation
import PumpyAnalytics

class SearchGridViewModel: GridViewModel, ObservableObject {

    @Published var itemsSelected = [PlaylistSnapshot]()
    @Published var displayedPlaylists = [PlaylistSnapshot]()
    let navigator: SearchNavigationManager
    
    init(navigator: SearchNavigationManager) {
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
            navigator.currentPage = SearchNavigation.playlist(playlist)
        }
    }
    
}
