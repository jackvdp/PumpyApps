//
//  Notifications.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 24/09/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation
import UIKit
import PumpyLibrary

extension AppDelegate {
    
    // MARK: - Notification SetUp
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for Remote Token. Error: \(error)")
    }
    
    // MARK: - Notification Manager
    
    // Remote notificaitons
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Tada")
        if let dataString = userInfo["action"] as? String {
            if let data = Data(base64Encoded: dataString) {
                let jsonDecoder = JSONDecoder()
                if let action = try? jsonDecoder.decode(RemoteInfo.self, from: data) {
                    accountManager.user?.remoteDataManager.respondToRemoteInfo(action)
                }
            }
        }
        
        completionHandler(.newData)
    }
    
}
