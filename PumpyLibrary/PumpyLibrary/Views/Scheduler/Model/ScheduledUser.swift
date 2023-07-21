//
//  ScheduledUser.swift
//  Scheduler
//
//  Created by Jack Vanderpump on 24/07/2022.
//

import Foundation

public protocol ScheduledUser {
    var username: Username { get }
    var alarmManager: AlarmManager? { get }
}

public class MockUser: UserProtocol {
    public init() {}
    
    public typealias P = MockPlaylistManager
    public typealias M = MockMusicMananger

    public var username: Username = .account("Test")
    public var alarmManager: AlarmManager? = AlarmManager()
    public var externalDisplayManager: ExternalDisplayManager<MockPlaylistManager>? = ExternalDisplayManager(
        username: .account("Test"),
        playlistManager: MockPlaylistManager()
    )
    public var settingsManager: SettingsManager? = SettingsManager()
    public var musicManager: MockMusicMananger? = MockMusicMananger()
}

public protocol ScheduledPlaylist {
    var name: String? { get }
    var cloudGlobalID: String? { get }
}
