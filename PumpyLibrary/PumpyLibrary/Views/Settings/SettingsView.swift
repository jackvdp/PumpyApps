//
//  SettingsView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 14/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsVM: SettingsManager
    
    var body: some View {
        PumpyList {
            generalSettings
            capabilitiesRow
        }
        .listStyle(.plain)
        .pumpyBackground()
        .toggleStyle(SwitchToggleStyle(tint: Color.pumpyPink))
        .accentColor(.pumpyPink)
        .navigationBarTitle("Settings")
    }
    
    var generalSettings: some View {
        Section {
            Toggle("Ban Explicit Content:", isOn: $settingsVM.onlineSettings.banExplicit)
            Toggle("Suspend Playlist Schedule \n(until 6am tomorrow):", isOn: $settingsVM.onlineSettings.overrideSchedule)
        }
    }
    
    var capabilitiesRow: some View {
        NavigationLink(destination: CapabilitiesView()) {
            MenuRow(title: "Capabilities", imageName: "bolt.fill")
                .padding(.horizontal, -10)
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
        .preferredColorScheme(.dark)
        .environmentObject(SettingsManager())
    }
}
