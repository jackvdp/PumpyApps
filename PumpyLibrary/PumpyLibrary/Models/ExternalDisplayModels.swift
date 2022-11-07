//
//  ExternalDisplayModels.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 19/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation

public struct ExtDisSettings: Codable {
    public init(displayContent: ExtDisContentType = .artworkAndTitles, showQRCode: Bool = true, qrType: QRType = .playlist, qrURL: String = String(), marqueeTextLabel: String = String(), marqueeLabelSpeed: Double = 5.0) {
        self.displayContent = displayContent
        self.showQRCode = showQRCode
        self.qrType = qrType
        self.qrURL = qrURL
        self.marqueeTextLabel = marqueeTextLabel
        self.marqueeLabelSpeed = marqueeLabelSpeed
    }
    
    public init() {}
    
    public var displayContent: ExtDisContentType = .artworkAndTitles
    public var showQRCode = true
    public var qrType: QRType = .playlist
    public var qrURL = String()
    public var marqueeTextLabel = String()
    public var marqueeLabelSpeed = 5.0
}

public enum ExtDisContentType: String, Codable, CaseIterable {
    case artworkAndTitles = "Track Information"
    case upNext = "Up Next"
    case upNextArtwokAndTitles = "Track Information & Up Next"
}

public enum QRType: String, Codable, CaseIterable {
    case playlist = "Playlist"
    case custom = "Custom"
}

public enum ExtDisType {
    case defualts
    case override
}

