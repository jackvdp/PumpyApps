//
//  UserProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 11/08/2022.
//

import Foundation

public protocol UserProtocol: ScheduledUser, ObservableObject {
    associatedtype P: PlaylistProtocol
    
    var username: String { get }
    var alarmManager: AlarmManager? { get }
    var settingsManager: SettingsManager? { get }
    var externalDisplayManager: ExternalDisplayManager<P>? { get }
}
