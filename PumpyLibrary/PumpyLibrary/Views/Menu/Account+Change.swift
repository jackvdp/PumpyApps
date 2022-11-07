//
//  Account+ChangePassword.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 31/08/2022.
//

import Foundation
import UIKit
import SwiftUI

extension AccountView {
    
    func showChangePasswordAlert() {
        TextAlert().generalTextAlert(title: "Change Password",
                                     message: "To change password, please enter your current password and the new password.",
                                     textFields: [
                                        TextAlert.AlertTextField(placeholder: "Current Password",
                                                                 secure: true,
                                                                 binding: { textField in
                                                                     passwordField = textField
                                                                 }),
                                        TextAlert.AlertTextField(placeholder: "New Password",
                                                                 secure: true,
                                                                 binding: { textField in
                                                                     newPasswordField = textField
                                                                 })
                                     ],
                                     defaultAction: changePasswordAction)
    }
    
    func changePasswordAction() {
        if self.passwordField.text == self.savedPassword() {
            if let newPassword = newPasswordField.text {
                changePassword(newPassword: newPassword)
            }
        } else {
            errorTitle = "Error"
            errorMessage = "Password change failed. Incorrect current password. Please try again."
            showError = true
        }
    }
    
    func changePassword(newPassword: String) {
        accountVM.changePassword(newPassword: newPassword) { success in
            if success {
                errorTitle = "Success"
                errorMessage = "Password changed successfully."
                showError = true
            } else {
                errorTitle = "Error"
                errorMessage = "Password change failed. Please try again."
                showError = true
            }
        }
    }

    func savedPassword() -> String {
        return UserDefaults.standard.string(forKey: K.password) ?? ""
    }
    
}


