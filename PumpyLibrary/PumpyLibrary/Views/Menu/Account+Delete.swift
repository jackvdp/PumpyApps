//
//  Account+Delete.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 31/08/2022.
//

import Foundation
import UIKit

extension AccountView {
    
    func showDeleteAlert() {
        TextAlert().generalTextAlert(title: "Delete Account",
                                     message: "To delete your account, please enter your current password.",
                                     textFields: [
                                        TextAlert.AlertTextField(placeholder: "Enter Password",
                                                                 secure: true,
                                                                 binding: { textField in
                                                                     passwordField = textField
                                                                 })
                                     ],
                                     defaultAction: deleteAction)
    }
    
    func deleteAction() {
        if self.passwordField.text == self.savedPassword() {
            deleteAccount()
        } else {
            errorTitle = "Error"
            errorMessage = "Password change failed. Incorrect current password. Please try again."
            showError = true
        }
    }
    
    func deleteAccount() {
        accountVM.deleteAccount() { success in
            if !success {
                errorTitle = "Error"
                errorMessage = "Delete account failed. Please try again."
                showError = true
            }
        }
    }
    
}
