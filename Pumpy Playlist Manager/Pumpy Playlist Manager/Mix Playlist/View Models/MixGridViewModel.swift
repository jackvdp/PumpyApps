//
//  MergeGridViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/06/2022.
//

import Foundation
import PumpyAnalytics

class MixGridViewModel: ObservableObject, GridViewModel {
    
    @Published var itemsSelected = [PlaylistSnapshot]()
    @Published var displayedPlaylists = [PlaylistSnapshot]()
    let navigator: MixNavigationManager
    
    init(navigator: MixNavigationManager) {
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
        itemsSelected.removeAll(where: { $0 == playlist})
    }
    
    func unSelectAllItems() {
        itemsSelected = []
    }
    
    func goToPlaylistView() {
        if let playlist = itemsSelected.first {
            navigator.currentPage = .playlistPreview(playlist)
        }
    }
    
    func mixPlaylists(_ playlists: [PlaylistSnapshot]) {
        navigator.currentPage = .mixerSettings(playlists, nil)
    }
    
}
