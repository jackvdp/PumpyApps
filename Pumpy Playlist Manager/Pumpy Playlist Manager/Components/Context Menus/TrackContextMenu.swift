//
//  TrackContextMenu.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct TrackContextMenu: View {
    
    let tracks: [Track]
    let currentTrack: Track
    @EnvironmentObject var controller: SavedPlaylistController
    @EnvironmentObject var createManager: CreateManager
    @EnvironmentObject var playerManager: PlayerManager
    var deleteAction: (() -> ())?
    
    var body: some View {
        Button {
            createManager.addRemoveManyFromTracksToCreate(focussedTracks())
        } label: {
            if createManager.tracksAreInPlace(focussedTracks()) {
                Label("Remove \(trackGrammer()) from create playlist",
                      systemImage: "trash")
                    .labelStyle(.titleAndIcon)
            } else {
                Label("Add \(trackGrammer()) to create playlist",
                      systemImage: "star.fill")
                    .labelStyle(.titleAndIcon)
            }
        }
        Divider()
        if let deleteAction = deleteAction {
            Button {
                deleteAction()
            } label: {
                Label("Delete \(trackGrammer()) from playlist copy",
                      systemImage: "trash")
                    .labelStyle(.titleAndIcon)
            }
        }
        Divider()
        Button {
            playerManager.playNow(tracks)
        } label: {
            Label("Play \(trackGrammer()) now", systemImage: "play.fill")
                .labelStyle(.titleAndIcon)
        }
        if playerManager.playerState == .playing {
            Button {
                playerManager.playNext(tracks)
            } label: {
                Label("Play \(trackGrammer()) next", systemImage: "plus")
                    .labelStyle(.titleAndIcon)
            }
        }
            
    }
    
    func focussedTracks() -> [Track] {
        if !tracks.contains(currentTrack) {
            return tracks + [currentTrack]
        } else {
            return tracks
        }
    }
    
    func trackGrammer() -> String {
        return focussedTracks().count == 1 ? "track" : "tracks (\(focussedTracks().count))"
    }

}

struct TrackContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        TrackContextMenu(tracks: MockData.tracks, currentTrack: MockData.track)
    }
}
