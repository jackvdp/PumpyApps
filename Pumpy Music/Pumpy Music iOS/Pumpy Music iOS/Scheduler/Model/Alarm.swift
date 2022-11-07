//
//  Alarm.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/23.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation
import PumpyLibrary

public struct Alarm: Codable, Equatable {
    public init(uuid: String, time: Time, playlistLabel: String, repeatStatus: [DetailInfo.DaysOfWeek], secondaryPlaylists: [SecondaryPlaylist]? = nil, externalSettingsOverride: Bool? = nil, showQRCode: Bool? = nil, QRLink: String? = nil, QRMessage: String? = nil, contentType: ExtDisContentType? = nil, messageSpeed: Double? = nil, qrType: QRType? = nil) {
        self.uuid = uuid
        self.time = time
        self.playlistLabel = playlistLabel
        self.repeatStatus = repeatStatus
        self.secondaryPlaylists = secondaryPlaylists
        self.externalSettingsOverride = externalSettingsOverride
        self.showQRCode = showQRCode
        self.QRLink = QRLink
        self.QRMessage = QRMessage
        self.contentType = contentType
        self.messageSpeed = messageSpeed
        self.qrType = qrType
    }
    
    public var uuid: String
    public var time: Time
    public var playlistLabel: String
    public var repeatStatus: [DetailInfo.DaysOfWeek]
    public var secondaryPlaylists: [SecondaryPlaylist]?

    public var externalSettingsOverride: Bool?
    public var showQRCode: Bool?
    public var QRLink: String?
    public var QRMessage: String?
    public var contentType: ExtDisContentType?
    public var messageSpeed: Double?
    public var qrType: QRType?
}

public struct SecondaryPlaylist: Codable, Equatable, Hashable, Identifiable {
    public init(name: String, ratio: Int, id: UUID = UUID()) {
        self.name = name
        self.ratio = ratio
        self.id = id
    }
    
    public var name: String
    public var ratio: Int
    public var id = UUID()
}

public struct Time: Codable, Equatable {
    public init(hour: Int, min: Int) {
        self.hour = hour
        self.min = min
    }

    public var hour: Int
    public var min: Int
    
    public var timeString: String {
        let formatter = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: .current)
        let dateFormatter = DateFormatter()
        
        if let formatter = formatter, formatter.contains("a") {
            dateFormatter.dateFormat  = "h:mma"
        } else {
            dateFormatter.dateFormat  = formatter
        }
        
        return dateFormatter.string(from: date)
    }
    
    public var date: Date {
        dateComponents.date!
    }

    public var dateComponents: DateComponents {
        DateComponents(calendar: Calendar.current, hour: hour, minute: min, second: 0)
    }
    
}

extension DetailInfo.DaysOfWeek: Codable {
    
}

extension Date {
    public var hour: Int { Calendar.current.component(.hour, from: self) }
    public var minute: Int { Calendar.current.component(.minute, from: self) }
}
