//
//  SceneDelegate.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 30/11/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import PumpyLibrary
import PumpyAnalytics

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var additionalWindows = [UIWindow]()
    
    // MARK: - Initial view set up
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.pumpyPink)
    
        
        let contentView = StartView()
            .onReceive(
                screenDidConnectPublisher,
                perform: screenDidConnect
            )
            .onReceive(
                screenDidDisconnectPublisher,
                perform: screenDidDisconnect
            )
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    // MARK: Scene Delegate Methods
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    // MARK: - External Display
    
    private var screenDidConnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didConnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private var screenDidDisconnectPublisher: AnyPublisher<UIScreen, Never> {
        NotificationCenter.default
            .publisher(for: UIScreen.didDisconnectNotification)
            .compactMap { $0.object as? UIScreen }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func screenDidConnect(_ screen: UIScreen) {
        let window = UIWindow(frame: screen.bounds)
        
        window.windowScene = UIApplication.shared.connectedScenes
            .first { ($0 as? UIWindowScene)?.screen == screen }
            as? UIWindowScene
        
//        let view = ExternalDisplayView<
//            AccountManager,
//            PlaylistManager,
//            NowPlayingManager,
//            QueueManager,
//            BlockedTracksManager,
//            AuthorisationManager
//        >()
//            .environmentObject(accountManager)
//        let controller = UIHostingController(rootView: view)
//        window.rootViewController = controller
//        window.isHidden = false
//        additionalWindows.append(window)
    }
    
    private func screenDidDisconnect(_ screen: UIScreen) {
        additionalWindows.removeAll { $0.screen == screen }
    }
    
}

