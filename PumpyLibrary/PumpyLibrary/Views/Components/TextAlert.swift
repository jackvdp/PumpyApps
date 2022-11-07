//
//  TextAlert.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 31/08/2022.
//

import Foundation
import UIKit

struct TextAlert {
    
    struct AlertTextField {
        var placeholder: String
        var secure: Bool
        var binding: (UITextField)->()
    }
    
    func generalTextAlert(title: String,
                          message: String,
                          textFields: [AlertTextField],
                          defaultAction: @escaping ()->()) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        for textField in textFields {
            alert.addTextField() { tf in
                tf.isSecureTextEntry = textField.secure
                tf.placeholder = textField.placeholder
                textField.binding(tf)
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default) { _ in
            defaultAction()
        })
        
        showAlert(alert: alert)
        
    }
    
    private func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .compactMap {$0 as? UIWindowScene}
            .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }
    
    private func topMostViewController(for controller: UIViewController) -> UIViewController {
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
}
