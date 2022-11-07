//
//  AMArtworkGateway.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/08/2022.
//

import Foundation

public class ArtworkGateway {
    public init() {}
    
    func getArtworkURL(id: String, storeFront: String, completionHandler: @escaping (String) -> Void) {
        if let musicURL = URL(string: "\(K.MusicStore.url)catalog/\(storeFront)/songs/\(id)") {
            var musicRequest = URLRequest(url: musicURL)
            musicRequest.httpMethod = "GET"
            musicRequest.addValue(K.MusicStore.bearerToken, forHTTPHeaderField: K.MusicStore.authorisation)

            URLSession.shared.dataTask(with: musicRequest) { [weak self] (data, response, error) in
                guard error == nil else { return }
                if let d = data {
                    if let artworkString = self?.parseTrackForArtwork(data: d) {
                        completionHandler(artworkString)
                    }
                }
            }.resume()
        }
    }
    
    func parseTrackForArtwork(data: Data) -> String? {
        let decoder = JSONDecoder()
        if let artworkStruct = try? decoder.decode(ArtworkStruct.self, from: data) {
            return artworkStruct.data.first?.attributes.artwork.url
        }
        return nil
    }
    
    private struct ArtworkStruct: Codable {
        var data: [ArtworkData]
        
        struct ArtworkData: Codable {
            var attributes: ArtworkAttributes
        }
        
        struct ArtworkAttributes: Codable {
            var artwork: ArtworkURL
        }
        
        struct ArtworkURL: Codable {
            var url: String
        }
    }
}

// Old SwiftyJSON Parser

//        if let jsonData = try? JSON(data: data) {
//            if let tracks = jsonData["data"].array {
//                for track in tracks {
//                    if let artworkURL = track["attributes"]["artwork"]["url"].string {
//                        return artworkURL
//                    }
//                }
//            }
//        }
//        return nil
