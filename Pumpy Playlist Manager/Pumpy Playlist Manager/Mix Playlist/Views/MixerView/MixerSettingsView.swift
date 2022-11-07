//
//  MixerSettignsView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/07/2022.
//

import SwiftUI
import PumpyAnalytics

struct MixerSettingsView: View {
    @ObservedObject var mixerVM: MixerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("New Playlist Settings:")
                .opacity(0.5)
            HStack {
                Text("Name:")
                TextField("Playlist name", text: $mixerVM.playlistName)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                SortMenuView(sortBy: $mixerVM.splitBy, ascending: $mixerVM.sortAcending)
                Spacer()
                Picker("Split into:", selection: $mixerVM.divideBy) {
                    ForEach(DivideBy.allCases) { divideBy in
                        Text("\(divideBy.rawValue)")
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 250)
            }
        }
        .padding()
        .background(.thickMaterial)
        .cornerRadius(8)
        .frame(maxWidth: 600)
    }
}

struct MixerSettignsView_Previews: PreviewProvider {
    static var previews: some View {
        MixerSettingsView(mixerVM:
                            MixerViewModel(
                                MockData.customPlaylist,
                                navManager: MixNavigationManager()
                            )
        ).padding()
    }
    
}
