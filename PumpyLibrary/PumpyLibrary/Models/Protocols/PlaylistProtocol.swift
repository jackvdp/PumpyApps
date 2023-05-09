//
//  PlaylistProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation
import MusicKit

public protocol PlaylistProtocol: ObservableObject {
    var playlistLabel: String { get set }
    func playLibraryPlayist(_ playlist: MusicKit.Playlist, when position: Position)
    func playLibraryPlayist(_ name: String,
                            secondaryPlaylists: [SecondaryPlaylist],
                            when position: Position)
    func playCatalogPlaylist(id: String, when position: Position)
    func playPlaylist(_ playlist: PumpyLibrary.Playlist, fromLibrary: Bool, when position: Position)
    func getLibraryPlaylists() async -> [PumpyLibrary.Playlist]
    func getLibraryPlaylistTracks(playlist: PumpyLibrary.Playlist) async -> [PumpyLibrary.Track]
}

public class MockPlaylistManager: PlaylistProtocol {
    public init() {}
    public var playlistLabel: String = String()
    public func playLibraryPlayist(_ playlist: MusicKit.Playlist, when position: Position) {}
    public func playLibraryPlayist(_ name: String,
                            secondaryPlaylists: [SecondaryPlaylist],
                                   when position: Position) {}
    public func playCatalogPlaylist(id: String, when position: Position) {}
    public func playPlaylist(_ playlist: PumpyLibrary.Playlist, fromLibrary: Bool, when position: Position) {}
    public func getLibraryPlaylists() async -> [PumpyLibrary.Playlist] { return [] }
    public func getLibraryPlaylistTracks(playlist: PumpyLibrary.Playlist) async -> [PumpyLibrary.Track] { return [] }
}

public enum Position: Equatable {
    case now, next, at(Int)
}
