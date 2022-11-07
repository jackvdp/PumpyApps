//
//  Alarm.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/23.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

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

extension DetailInfo.DaysOfWeek: Codable {}

extension Date {
    public var hour: Int { Calendar.current.component(.hour, from: self) }
    public var minute: Int { Calendar.current.component(.minute, from: self) }
}

@propertyWrapper struct AlarmSort {
    var wrappedValue: [Alarm] {
        didSet { wrappedValue = wrappedValue.sortAlarms() }
    }
    
    init(wrappedValue: [Alarm]) {
        self.wrappedValue = wrappedValue.sortAlarms()
    }
    
}

extension Array where Element == Alarm {
    func sortAlarms() -> [Alarm] {
        self.sorted {
            if $0.time.date.hour < 6, $1.time.date.hour >= 6 { return false }
            if $1.time.date.hour < 6, $0.time.date.hour >= 6 { return true  }
            return ($0.time.date.hour, $0.time.date.minute) < ($1.time.date.hour, $1.time.date.minute)
        }
    }
    
    /// Gets next alarm in the same day.
    /// - Returns: The next alarm. Equals nil if no future alarm
    public func getNextAlarm(date: Date = Date()) -> Alarm? {
        let currentDay = DetailInfo.getCurrentDayFormatted(date: date)
        let todaysAlarms = self.filter { $0.repeatStatus.isEmpty || $0.repeatStatus.contains(currentDay)}
        
        let currentHour = Calendar.current.component(.hour, from: date)
        let currentMinute = Calendar.current.component(.minute, from: date)
        
        var futureAlarms = todaysAlarms.filter { $0.time.hour >= currentHour }
        futureAlarms.removeAll(where: { $0.time.hour == currentHour && $0.time.min <= currentMinute})
        
        futureAlarms.sort(by: {
            if $0.time.hour == $1.time.hour {
                return $0.time.min < $1.time.min
            } else {
                return $0.time.hour < $1.time.hour
            }
        })
        
        return futureAlarms.first
    }
    
    /// Gets most recent alarm.
    /// - Returns: The most recent alarm, or if nil, the next alarm in the same day. Returns nil if no alarms on that day.
    public func getMostRecentAlarm(date: Date = Date()) -> Alarm? {
        let currentDay = DetailInfo.getCurrentDayFormatted(date: date)
        let todaysAlarms = self.filter { $0.repeatStatus.isEmpty || $0.repeatStatus.contains(currentDay)}
        
        let currentHour = Calendar.current.component(.hour, from: date)
        let currentMinute = Calendar.current.component(.minute, from: date)
        
        var pastAlarms = todaysAlarms.filter { $0.time.hour <= currentHour }
        pastAlarms.removeAll(where: { $0.time.hour == currentHour && $0.time.min > currentMinute })
        
        if currentHour >= 6 {
            pastAlarms.removeAll(where: { $0.time.hour < 6 })
        }
        
        pastAlarms.sort(by: {
            if $0.time.hour == $1.time.hour {
                return $0.time.min < $1.time.min
            } else {
                return $0.time.hour < $1.time.hour
            }
        })
        
        return pastAlarms.last != nil ? pastAlarms.last : self.getNextAlarm(date: date)
    }
}

extension Alarm? {
    /// Convert alarm into Date
    /// - Returns: Date of alarm or midnight if Alarm is nil
    public func date() -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        if let self = self {
            var dateComponents = calendar.dateComponents(in: .current, from: Date())
            dateComponents.hour = self.time.hour
            dateComponents.minute = self.time.min
            dateComponents.second = 0
            return Calendar(identifier: .gregorian).date(from: dateComponents)
        } else {
            let midnight = calendar.startOfDay(for: Date())
            return calendar.date(byAdding: .day, value: 1, to: midnight)
        }
    }
}
