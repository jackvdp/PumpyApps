//
//  LibraryViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 16/02/2022.
//

import Foundation
import PumpyAnalytics

protocol GridViewModel: ObservableObject {
    
    associatedtype NavigationManager

    var itemsSelected: [PlaylistSnapshot] { get set}
    var displayedPlaylists: [PlaylistSnapshot] { get set}
    var navigator: NavigationManager { get }
    
    func toggleSelectItem(playlist: PlaylistSnapshot)
    
    func selectItem(playlist: PlaylistSnapshot)
    
    func unSelectItem(playlist: PlaylistSnapshot)
    
    func unSelectAllItems()
    
    func goToPlaylistView()
    
}
