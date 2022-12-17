//
//  ScheduledUser.swift
//  Scheduler
//
//  Created by Jack Vanderpump on 24/07/2022.
//

import Foundation

public protocol ScheduledUser {
    var username: String { get }
    var alarmManager: AlarmManager? { get }
}

class MockUser: UserProtocol {
    typealias P = MockPlaylistManager
    typealias M = MockMusicMananger

    var username: String = "Test"
    var alarmManager: AlarmManager? = AlarmManager()
    var externalDisplayManager: ExternalDisplayManager<MockPlaylistManager>? = ExternalDisplayManager(username: "Test",
                                                                                                      playlistManager: MockPlaylistManager())
    var settingsManager: SettingsManager? = SettingsManager()
    var musicManager: MockMusicMananger? = MockMusicMananger()
}

public protocol ScheduledPlaylist {
    var name: String? { get }
    var cloudGlobalID: String? { get }
}
