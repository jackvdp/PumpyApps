//
//  ExternalDisplayModels.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 19/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation

struct ExtDisSettings: Codable {
    var displayContent: ExtDisContentType = .artworkAndTitles
    var showQRCode = true
    var qrType: QRType = .playlist
    var qrURL = String()
    var marqueeTextLabel = String()
    var marqueeLabelSpeed = 5.0
}

enum ExtDisContentType: String, Codable, CaseIterable {
    case artworkAndTitles = "Track Information"
    case upNext = "Up Next"
    case upNextArtwokAndTitles = "Track Information & Up Next"
    //    case lyrics = "Lyrics"
    //    case lyricsArtwokAndTitles = "Track Information & Lyrics"
    //    case lyricsUpNext = "Lyrics & Up Next"
}

enum QRType: String, Codable, CaseIterable {
    case playlist = "Playlist"
    case custom = "Custom"
}

enum ExtDisType {
    case defualts
    case override
}

