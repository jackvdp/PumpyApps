//
//  SettingsView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 14/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

struct SettingsView: View {
    
    @EnvironmentObject var settingsVM: SettingsManager
    @State var passwordField = UITextField()
    @State var revealAdminSettings: Bool = false
    
    var body: some View {
        PumpyList {
            generalSettings
            if revealAdminSettings {
                passwordProtectedSettings
            }
            capabilitiesRow
            if !revealAdminSettings {
                unlockButton
            }
        }
        .pumpyBackground()
        .toggleStyle(SwitchToggleStyle(tint: Color.pumpyPink))
        .accentColor(.pumpyPink)
        .navigationBarTitle("Settings")
    }
    
    var generalSettings: some View {
        Section {
            Toggle("Use Crossfade", isOn: $settingsVM.onlineSettings.crossfadeOn)
            Toggle("Ban Explicit Content:", isOn: $settingsVM.onlineSettings.banExplicit)
            Toggle("Suspend Playlist Schedule \n(until 6am tomorrow):", isOn: $settingsVM.onlineSettings.overrideSchedule)
        }
    }
    
    @ViewBuilder
    var passwordProtectedSettings: some View {
        Section {
            Toggle("Show Music Library", isOn: $settingsVM.onlineSettings.showMusicLibrary)
            Toggle("Show Music Store", isOn: $settingsVM.onlineSettings.showMusicStore)
            Toggle("Show Playlist Scheduler:", isOn: $settingsVM.onlineSettings.showScheduler)
            Toggle("Show External Display:", isOn: $settingsVM.onlineSettings.showExternalDisplay)
        }
    }
    
    var capabilitiesRow: some View {
        NavigationLink(destination: CapabilitiesView()) {
            MenuRow(title: "Capabilities", imageName: "bolt.fill")
                .padding(.horizontal, -10)
        }
    }
    
    var unlockButton: some View {
        Button {
            lockSettingsAlert()
        } label: {
            HStack {
                Image(systemName: "lock.fill").foregroundColor(.white)
                Text("Access Admin Settings")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var settingsView = SettingsView(revealAdminSettings: true)
    
    static var previews: some View {
        settingsView
            .environmentObject(SettingsManager())
    }
}
