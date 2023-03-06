//
//  Artwork.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import PumpyAnalytics

public class ArtworkHandler {
    
    public init() {}
    
    private let gateway = ArtworkGateway()

    public func getArtwork(from track: Track,
                           size: Int,
                           authManager: any TokenProtocol,
                           completion: @escaping (URL?) -> Void) {
        if let artworkString = track.artworkURL {
            completion(Self.makeMusicStoreURL(artworkString, size: size))
        } else {
            guard let id = track.playbackStoreID,
                  let storefront = authManager.appleMusicStoreFront else { return }
            gateway.getArtworkURL(id: id, storeFront: storefront) { (artworkString) in
                completion(Self.makeMusicStoreURL(artworkString, size: size))
            }
        }
    }
    
    public static func makeMusicStoreURL(_ urlString: String, size: Int) -> URL? {
        let string = urlString
            .replacingOccurrences(of: "{w}", with: String(size))
            .replacingOccurrences(of: "{h}", with: String(size))
            .replacingOccurrences(of: "%w", with: String(size))
            .replacingOccurrences(of: ArtworkHandler.key.description, with: String(size))
        
        if let url = URL(string: string) {
            return url
        } else {
            print("Error getting artwork from: \(string)")
            return nil
        }
    }
    
    public static let key = 135792468
}
