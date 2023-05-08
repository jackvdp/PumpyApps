//
//  Playlist.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 18/05/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import MusicKit
import PumpyLibrary
import MediaPlayer

class MusicContent {
    
    func getPlaylists(completion: @escaping ([PumpyLibrary.Playlist]) -> ()) {
        Task {
            do {
                let request = MusicLibraryRequest<MusicKit.Playlist>()
                let response = try await request.response()
                let playlists = response.items.map { $0 as MusicKit.Playlist }
                let sorted = playlists.sorted { $0.name < $1.name }
                completion(sorted)
            } catch {
                print(error)
            }
        }
    }
    
    static func getTracks(for playlist: PumpyLibrary.Playlist,
                          completion: @escaping ([PumpyLibrary.Track]) -> ()) {
        Task {
            do {
                let mkPlaylist = playlist as! MusicKit.Playlist
                let playlistWithTracks = try await mkPlaylist.with(.tracks)
                let tracks = playlistWithTracks.tracks?.map { $0 as MusicKit.Track }
                completion(tracks ?? [])
            } catch {
                print(error)
            }
        }
    }
    
    static func getListOfPlaylistNames() -> [String] {
        if let playlistsAndFolders = MPMediaQuery.playlists().collections {
            let playlists = playlistsAndFolders.filter { !($0.value(forProperty: "isFolder") as? Bool ?? false) }
            return playlists.map { $0.value(forProperty: MPMediaPlaylistPropertyName)! as! String }
        }
        return []
    }

}
