//
//  BlockecTrackViewModel.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

class BlockedTrackViewModel: ObservableObject {
    
    let id: String
    let token: String
    let storeFront: String
    let defaultArtwork = UIImage(imageLiteralResourceName: K.defaultArtwork)
    
    init(_ blockedTrack: BlockedTrack, token: String, storeFront: String) {
        self.id = blockedTrack.playbackID
        self.token = token
        self.storeFront = storeFront
        self.trackTitle = blockedTrack.title
        self.trackArtist = blockedTrack.artist ?? String()
        self.isExplicit = blockedTrack.isExplicit ?? false
        loadTrackData()
    }
    
    @Published var trackTitle: String?
    @Published var trackArtist: String
    @Published var isExplicit: Bool
    @Published var artwork = UIImage(imageLiteralResourceName: K.defaultArtwork)
    @Published var loadingSpinnerOn = true
    
    func loadTrackData() {
//        let amAPI = AppleMusicAPI(token: token, storeFront: storeFront)
//        amAPI.getTrackFromID(item: id) { item in
//            if let i = item {
//                DispatchQueue.main.async {
//                    self.trackTitle = i.name
//                    self.trackArtist = i.artistName
//                    self.loadingSpinnerOn = false
//                }
//                self.loadArtwork(i.artworkURL)
//            }
//        }
    }
    
    func loadArtwork(_ artworkURL: String) {
//        if let url = ArtworkHandler.makeMusicStoreURL(artworkURL, size: 50) {
//            ArtworkHandler.fetchImage(from: url) { image in
//                if let i = image {
//                    DispatchQueue.main.async {
//                        self.artwork = i
//                    }
//                }
//            }
//        }
    }
}
