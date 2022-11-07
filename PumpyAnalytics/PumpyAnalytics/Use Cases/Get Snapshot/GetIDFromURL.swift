//
//  GetSnapshotFromID.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 09/06/2022.
//

import Foundation

class GetIDFromURL {
    
    func execute(_ playlistURL: String) -> (PlaylistSnapshot?, ErrorMessage?) {
        var errorMessage: ErrorMessage?
        
        if let url = URL(string: playlistURL) {
            if let snapshot = determineWhereURLisFrom(url) {
                return (snapshot, nil)
            }
        }
        
        errorMessage = ErrorMessage("Invalid URL", "Please provide a URL containing the playlist ID as the final component.")
        return (nil, errorMessage)
    }
    
    
    private func determineWhereURLisFrom(_ url: URL) -> PlaylistSnapshot? {
        guard let host = url.host else { return nil }
        let id = url.lastPathComponent
        
        if host.contains("spotify") {
            return makePlaylist(id: id, type: .spotify(id: id))
        } else if host.contains("music.apple") {
            return makePlaylist(id: id, type: .am(id: id))
        } else if host.contains("soundtrackyourbrand") {
            return makePlaylist(id: id, type: .syb(id: id))
        }
        
        return nil
    }

    private func makePlaylist(id: String, type: PlaylistType) -> PlaylistSnapshot {
        return PlaylistSnapshot(name: "Searched Playlist",
                                artworkURL: nil,
                                shortDescription: nil,
                                sourceID: id,
                                type: type)
    }
}
