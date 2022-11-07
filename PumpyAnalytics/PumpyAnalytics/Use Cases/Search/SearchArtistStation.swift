//
//  SearchArtistStation.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 02/08/2022.
//

import Foundation
import Apollo

class SearchArtistStation {
    
    func run(_ term: String, completion: @escaping (PlaylistSnapshot?, ErrorMessage?) -> ()) {
        let query = SearchForArtistStationQuery(query: term)
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
    
    private func dealWithData(_ data: GraphQLResult<SearchForArtistStationQuery.Data>) -> (PlaylistSnapshot?, ErrorMessage?) {
        guard let artist = data.data?.search?.edges?.first else {
            return (nil, ErrorMessage("Error conducting search", "Error loading data."))
        }

        if let artist = artist?.node?.asArtist?.station {

            let libPlaylist = PlaylistSnapshot(name: artist.name,
                                              artworkURL: artist.display?.image?.placeholder,
                                              shortDescription: artist.shortDescription,
                                              sourceID: artist.id,
                                              type: .syb(id: artist.id))

            return (libPlaylist, nil)
        }

        return (nil, nil)
    }
    
}
