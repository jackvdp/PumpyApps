//
//  PlaylistProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol PlaylistProtocol: ObservableObject {
    var playlistLabel: String { get set }
    var playlistURL: String { get set }
    func playNext(playlist: PumpyLibrary.Playlist, secondaryPlaylists: [SecondaryPlaylist])
    func playNow(playlist: PumpyLibrary.Playlist, secondaryPlaylists: [SecondaryPlaylist])
}

public class MockPlaylistManager: PlaylistProtocol {
    public init() {}
    public var playlistLabel: String = String()
    public var playlistURL: String = String()
    public func playNext(playlist: PumpyLibrary.Playlist, secondaryPlaylists: [SecondaryPlaylist] = []) {}
    public func playNow(playlist: PumpyLibrary.Playlist, secondaryPlaylists: [SecondaryPlaylist] = []) {}
}
