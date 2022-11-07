//
//  PlaylistSheetView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 04/03/2022.
//

import SwiftUI
import PumpyAnalytics

struct MixerView: View {
    
    @StateObject var mixerVM: MixerViewModel
    @StateObject var observerVM: ObserveTracksViewModel
    @State private var readyToMix = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            MixerSettingsView(mixerVM: mixerVM)
            VStack(alignment: .leading) {
                Text("\(mixerVM.playlist.tracks.count) tracks")
                    .opacity(0.5)
                ButtonsView(playlistVM: mixerVM, observedVM: observerVM)
                MixerTracksView(mixerVM: mixerVM, observeVM: observerVM)
                HStack {
                    PlaylistStatusView(
                        viewModel: observerVM)
                    Spacer()
                    Button(readyToMix ? "Create" : "Analysing...") {
                        mixerVM.createPlaylist()
                    }
                    .disabled(!readyToMix)
                    .keyboardShortcut(.defaultAction)
                    .animation(.default, value: readyToMix)
                }
            }
        }
        .onChange(of: observerVM.tracksGettingStats) { newValue in
            withAnimation {
                readyToMix = newValue == 0
            }
        }
    }
}

struct PlaylistSheetView_Previews: PreviewProvider {
    
    static var previews: some View {
        MixerView(mixerVM: MixerViewModel(
            MockData.customPlaylist,
            navManager: MixNavigationManager()
        ), observerVM: ObserveTracksViewModel(MockData.customPlaylist))
            .frame(width: 1300, height: 800)
            .environmentObject(PlayerManager())
            .padding()
    }
}
