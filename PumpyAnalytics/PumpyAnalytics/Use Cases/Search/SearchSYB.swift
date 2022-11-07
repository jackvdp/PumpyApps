//
//  SYBSearch.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/04/2022.
//

import Foundation
import Apollo

class SearchSYB {
    
    func run(_ term: String, completion: @escaping ([PlaylistSnapshot]?, ErrorMessage?) -> ()) {
        let query = SearchQuery(query: term, type: .playlist)
        ApolloClass.shared.client.fetch(query: query) { result in
            switch result {
            case .success(let data):
                let playlists = self.dealWithData(data)
                completion(playlists.0, playlists.1)
            case .failure(let error):
                let errorMessage = ErrorMessage("Error conducting search", "Error loading data: \(error.localizedDescription).")
                completion(nil, errorMessage)
            }
        }
    }
    
    private func dealWithData(_ data: GraphQLResult<SearchQuery.Data>) -> ([PlaylistSnapshot]?, ErrorMessage?) {
        guard let playlists = data.data?.search?.edges else {
            return (nil, ErrorMessage("Error conducting search", "Error loading data."))
        }
        
        var libraryPlaylists = [PlaylistSnapshot]()
        
        for playlist in playlists {
            if let playlist = playlist?.node?.asPlaylist {
                
                let libPlaylist = PlaylistSnapshot(name: playlist.name,
                                                  artworkURL: playlist.display?.image?.placeholder,
                                                  shortDescription: playlist.shortDescription,
                                                  sourceID: playlist.id,
                                                  type: .syb(id: playlist.id))
                
                libraryPlaylists.append(libPlaylist)
            }
        }
        
        return (libraryPlaylists, nil)
    }
    
}
