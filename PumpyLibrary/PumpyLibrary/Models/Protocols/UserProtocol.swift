//
//  UserProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 11/08/2022.
//

import Foundation

public protocol UserProtocol: ScheduledUser, ObservableObject {
    
    associatedtype M: MusicProtocol
    associatedtype P: PlaylistProtocol
    
    var username: String { get }
    var alarmData: AlarmManager { get }
    var settingsManager: SettingsManager { get }
    var externalDisplayManager: ExternalDisplayManager<P> { get }
    var musicManager: M { get }
}
