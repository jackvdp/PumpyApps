//
//  LockAlertView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 29/06/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

extension SettingsView {
    
    func lockSettingsAlert() {
        let alert = UIAlertController(title: "Show Admin Settings",
                                      message: "Enter password for the account \(savedUsername()) to access admin settings",
                                      preferredStyle: .alert)
       
        alert.addTextField() { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Enter password"
            self.passwordField = textField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in

        })
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default) { _ in
            if self.passwordField.text == self.savedPassword() {
                revealAdminSettings = true
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Incorrect password.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Okay", style: .default))
                DispatchQueue.main.async {
                    self.showAlert(alert: errorAlert)
                }
            }
//            UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: {})
        })
        
        showAlert(alert: alert)
    }
    
    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }
    
    func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .compactMap {$0 as? UIWindowScene}
            .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }
    
    func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
    func savedUsername() -> String {
        return settingsVM.username
    }
    func savedPassword() -> String {
        return UserDefaults.standard.string(forKey: K.password) ?? ""
    }
    
}
