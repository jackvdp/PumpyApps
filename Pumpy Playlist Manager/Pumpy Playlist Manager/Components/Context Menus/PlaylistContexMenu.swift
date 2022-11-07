//
//  ContextMenu.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct PlaylistContexMenu: View {
    
    let playlist: PlaylistSnapshot
    var onHoverEnabled = false
    @State private var isHoveringItem1 = false
    @State private var isHoveringItem2 = false
    @EnvironmentObject var controller: SavedPlaylistController
    @EnvironmentObject var createManager: CreateManager
    
    var body: some View {
        Button {
            controller.addRemovePlaylistFromLibrary(playlist)
        } label: {
            if controller.isInLibrary(playlist) {
                Label("Remove from saved playlists", systemImage: "trash")
                    .labelStyle(.titleAndIcon)
            } else {
                Label("Add to saved playlists", systemImage: "music.note.list")
                    .labelStyle(.titleAndIcon)
            }
        }
        .foregroundColor(isHoveringItem1 ? .pumpyPink : nil)
        .onHover { isHovering in
            if onHoverEnabled {
                self.isHoveringItem1 = isHovering
            }
        }
        Button {
            createManager.addRemoveFromPlaylistsToMix(playlist)
        } label: {
            if createManager.playlistsToMegre.contains(playlist) {
                Label("Remove from playlist mixer", systemImage: "trash")
                    .labelStyle(.titleAndIcon)
            } else {
                Label("Add to playlist mixer", systemImage: "shuffle")
                    .labelStyle(.titleAndIcon)
            }
        }
        .foregroundColor(isHoveringItem2 ? .pumpyPink : nil)
        .onHover { isHovering in
            if onHoverEnabled {
                self.isHoveringItem2 = isHovering
            }
        }
    }

}

struct ContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistContexMenu(playlist: MockData.snapshot)
    }
}
