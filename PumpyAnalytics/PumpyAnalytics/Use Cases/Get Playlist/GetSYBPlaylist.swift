//
//  GetSYBPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/03/2022.
//

import Foundation
import Apollo

class GetSYBPlaylist {
    
    let authManager: AuthorisationManager
    let libraryPlaylist: PlaylistSnapshot
    
    init(libraryPlaylist: PlaylistSnapshot, authManager: AuthorisationManager) {
        self.authManager = authManager
        self.libraryPlaylist = libraryPlaylist
    }
    
    func execute(sybID: String, completion: @escaping (Playlist?, ErrorMessage?) -> ()) {
        let query = GetPlaylistQuery(playlistID: sybID)
        ApolloClass.shared.client.fetch(query: query) { result in
            switch result {
            case .success(let data):
                let parsing = self.dealWithData(data, playlistID: sybID)
                completion(parsing.0, parsing.1)
            case .failure(let error):
                let errorMessage = ErrorMessage("Error loading Playlist", "Error loading data: \(error.localizedDescription).")
                completion(nil, errorMessage)
            }
        }
    }
    
    private func dealWithData(_ data: GraphQLResult<GetPlaylistQuery.Data>, playlistID: String) -> (SYBPlaylist?, ErrorMessage?) {

        if let playlist = data.data?.playlist {

            if let tracks = playlist.tracks?.edges {

//              let genres = playlist.genres?.edges ?? []

                let decodedTracks: [Track] = tracks.compactMap { track in
                    let trk = track.node
                    if let isrc = trk.isrc {

                        return Track(
                            title: trk.title,
                            artist: trk.artists?.first?.name ?? "N/A",
                            album: trk.album?.title ?? "N/A",
                            isrc: isrc,
                            artworkURL: trk.display?.image?.placeholder,
                            previewUrl: trk.previewUrl,
                            isExplicit: trk.explicit ?? false,
                            sourceID: trk.id,
                            authManager: authManager,
                            spotifyItem: getItemFromShareURL(trk.shareUrl, for: trk)
                        )
                    } else {
                        return nil
                    }
                }

                let playlistRecieved = SYBPlaylist(name: playlist.name,
                                                   curator: playlist.curator?.name ?? "SoundTrackYourBrand",
                                                   tracks: decodedTracks,
                                                   artworkURL: playlist.display?.image?.placeholder,
                                                   description: playlist.description,
                                                   shortDescription: playlist.shortDescription,
                                                   sybID: playlistID,
                                                   authManager: authManager)

                return (playlistRecieved, nil)
            }
        }
        let errorMessage = ErrorMessage("Error loading Playlist", "Error loading data: Invalid Playlist ID.")
        return (nil, errorMessage)
    }
    
    func getItemFromShareURL(_ urlString: String?, for track: GetPlaylistQuery.Data.Playlist.Track.Edge.Node) -> SpotifyItem? {
        guard let urlString = urlString else {
            return nil
        }

        if let url = URL(string: urlString), let isrc = track.isrc {
            return SpotifyItem(isrc: isrc, id: url.lastPathComponent, year: nil, popularity: track.recognizability)
        }
        return nil
    }
}
