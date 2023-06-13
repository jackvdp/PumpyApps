//
//  AppDelegate.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/09/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import UIKit
import Foundation
import Siren
import PumpyLibrary

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    weak var remoteDataManager: RemoteManager?
    weak var scheduleManager: ScheduleManager?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        firebaseSetup()
        uiSetup()
        setupSiren()
        return true
    }
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Reset alarm timer after app comes out of suspended state
        scheduleManager?.setUpPlaylistChangeTimer()
    }
    
    func firebaseSetup() {
        FirebaseStore.shared.configure()
    }
    
    func uiSetup() {
        window?.overrideUserInterfaceStyle = .dark
        window?.tintColor = UIColor.white
        UISwitch.appearance().onTintColor = UIColor(named: K.pumpyPink)!
    }
    
    func setupSiren() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(alertTintColor: UIColor(named: K.pumpyPink)!)
        siren.rulesManager = RulesManager(globalRules: .default)
        siren.wail()
    }

}
