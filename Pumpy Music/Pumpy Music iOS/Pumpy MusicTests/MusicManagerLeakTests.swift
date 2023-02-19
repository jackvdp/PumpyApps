//
//  Pumpy_MusicTests.swift
//  Pumpy MusicTests
//
//  Created by Jack Vanderpump on 12/12/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import XCTest
@testable import Pumpy_Music
import PumpyLibrary
import PumpyAnalytics
import MediaPlayer

final class MusicManagerTests: XCTestCase {

    func testMusicManagerIsLeaking() {

        var x: MusicManager? = MusicManager(username: "Test",
                                            settingsManager: SettingsManager(username: "Test"))
        
        x?.authManager.fetchTokens()
        weak var leakReference = x
        x = nil
        
        XCTAssertNil(leakReference)
    }
    
    func testUserIsLeaking() {

        var x: User? = User(username: "test")
        
        x?.musicManager.authManager.fetchTokens()
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testAccountUserIsLeaking() {
        let account = AccountManager()
        account.user = User(username: "test")
        
        account.user?.musicManager.authManager.fetchTokens()
        weak var leakReference = account.user
        account.user = nil

        XCTAssertNil(leakReference)
    }
    
    func testAccountIsLeaking() {
        var x: AccountManager? = AccountManager()
        x?.user = User(username: "test")
        
        x?.user?.musicManager.authManager.fetchTokens()
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testAccountWithUserIsLeaking() {
        var x: AccountManager? = AccountManager()
        x?.user = User(username: "test")
        
        x?.user?.musicManager.authManager.fetchTokens()
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testAuthIsLeaking() {
        var x: AuthorisationManager? = AuthorisationManager()
        
        x?.fetchTokens()
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testRemoteIsLeaking() {
        var x: RemoteManager? = RemoteManager(username: "Test",
                                              musicManager: MusicManager(username: "Test",
                                                                         settingsManager: SettingsManager(username: "Test")),
                                              alarmManager: AlarmManager(username: "Test"))
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testAlarmIsLeaking() {
        var x: AlarmManager? = AlarmManager(username: "Test")
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testExternalDisplayIsLeaking() {
        let authManager = AuthorisationManager()
        authManager.fetchTokens()
        let queueManager = QueueManager(name: "test", authManager: authManager)
        let blockedTracks = BlockedTracksManager(username: "test", queueManager: queueManager)
        let playlistManager = PlaylistManager(blockedTracksManager: blockedTracks,
                                              settingsManager: SettingsManager(username: "test"),
                                              tokenManager: authManager,
                                              queueManager: queueManager,
                                              controller: MPMusicPlayerController.applicationQueuePlayer)
        var x: ExternalDisplayManager? = ExternalDisplayManager(username: "test",
                                                                playlistManager: playlistManager)
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testBlockedIsLeaking() {
        let authManager = AuthorisationManager()
        authManager.fetchTokens()
        let queueManager = QueueManager(name: "test", authManager: authManager)
        var x: BlockedTracksManager? = BlockedTracksManager(username: "test", queueManager: queueManager)
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testQueueIsLeaking() {
        let authManager = AuthorisationManager()
        authManager.fetchTokens()
        var x: QueueManager? = QueueManager(name: "test", authManager: authManager)
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testPlaylistIsLeaking() {
        let authManager = AuthorisationManager()
        authManager.fetchTokens()
        let queueManager = QueueManager(name: "test", authManager: authManager)
        let blockedTracks = BlockedTracksManager(username: "test", queueManager: queueManager)
        var x: PlaylistManager? = PlaylistManager(blockedTracksManager: blockedTracks,
                                               settingsManager: SettingsManager(username: "test"),
                                               tokenManager: authManager,
                                               queueManager: queueManager,
                                               controller: MPMusicPlayerController.applicationQueuePlayer)
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testSettingsIsLeaking() {
        var x: SettingsManager? = SettingsManager(username: "Test")
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testNowPlayingIsLeaking() {
        let authManager = AuthorisationManager()
        authManager.fetchTokens()
        var x: NowPlayingManager? = NowPlayingManager(authManager: authManager)
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testScheduleIsLeaking() {
        var x: ScheduleManager? = ScheduleManager()
        
        weak var leakReference = x
        x = nil

        XCTAssertNil(leakReference)
    }
    
    func testMusicManagerInAccountIsLeaking() {
        let accountManager = AccountManager()
        accountManager.user = User(username: "test")
        
        weak var leakReference = accountManager.user?.musicManager
        accountManager.user = nil

        XCTAssertNil(leakReference)
    }
    
    func testBlockedManagerInAccountIsLeaking() {
        let accountManager = AccountManager()
        accountManager.user = User(username: "test")
        
        weak var leakReference = accountManager.user?.musicManager.blockedTracksManager
        accountManager.user = nil

        XCTAssertNil(leakReference)
    }
    
    func testNowManagerInAccountIsLeaking() {
        let accountManager = AccountManager()
        accountManager.user = User(username: "test")
        
        weak var leakReference = accountManager.user?.musicManager.nowPlayingManager
        accountManager.user = nil

        XCTAssertNil(leakReference)
    }
    
    func testPlaylistManagerInAccountIsLeaking() {
        let accountManager = AccountManager()
        accountManager.user = User(username: "test")
        
        weak var leakReference = accountManager.user?.musicManager.playlistManager
        accountManager.user = nil

        XCTAssertNil(leakReference)
    }
    
    func testQueueManagerInAccountIsLeaking() {
        let accountManager = AccountManager()
        accountManager.user = User(username: "test")
        
        weak var leakReference = accountManager.user?.musicManager.queueManager
        accountManager.user = nil

        XCTAssertNil(leakReference)
    }
    
    func testAuthManagerInAccountIsLeaking() {
        let accountManager = AccountManager()
        
        weak var leakReference = accountManager.user?.musicManager.authManager
        accountManager.user = nil

        XCTAssertNil(leakReference)
    }
    
    func testQueueManagerInAccountIsLeakingAndFunctionDoestRun() {
        let accountManager = AccountManager()
        accountManager.user = User(username: "test")
        let promise = expectation(description: "Don't get error after call")
        
        weak var leakReference = accountManager.user?.musicManager.queueManager
        accountManager.user = nil

        XCTAssertNil(leakReference)
        
        wait(for: [promise], timeout: 5)
        
        XCTAssert(<#T##expression: Bool##Bool#>)
    }

}
