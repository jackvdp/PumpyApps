//
//  DuplicateAlarmsView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 31/08/2022.
//

import SwiftUI
import UIKit

struct DuplicateAlarmsView: View {
    
    @State var usernameTextField = UITextField()
    @EnvironmentObject var alarmData: AlarmManager
    
    var body: some View {
        ImageButtonView()
            .onTapGesture {
                showReplicateAlert()
            }
    }
    
    func showReplicateAlert() {
        TextAlert().generalTextAlert(title: "Replicate Schedule",
                                     message: "Enter the account name of the schedule you want to replicate.",
                                     textFields: [
                                        TextAlert.AlertTextField(placeholder: "Username",
                                                                 secure: false,
                                                                 binding: { textField in
                                                                     usernameTextField = textField
                                                                 })
                                     ]) {
                                         if let user = usernameTextField.text {
                                             alarmData.loadOtherUsersData(from: user)
                                         }
                                     }
    }
    
    struct ImageButtonView: View {
        var body: some View {
            Image(systemName: "link")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(Color.pumpyPink)
                .clipShape(Circle())
                .shadow(color: .black, radius:10)
                .padding()
        }
    }
    
}

struct DuplicateAlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        DuplicateAlarmsView()
    }
}
