//
//  MixerTracksView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/07/2022.
//

import SwiftUI
import PumpyAnalytics

struct MixerTracksView: View {
    @ObservedObject var mixerVM: MixerViewModel
    @ObservedObject var observeVM: ObserveTracksViewModel
    @State var columns = ColumnsShowing()
    
    var body: some View {
        SortSearchView(playlistVM: mixerVM,
                       showColumns: columns,
                       observeVM: observeVM)
        TracksView(tracks: mixerVM.displayedTracks,
                   deleteAction: mixerVM.deleteTracks,
                   columnsShowing: columns)
    }
}

struct MixerTracksView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            MixerTracksView(mixerVM:
                                MixerViewModel(
                                    MockData.customPlaylist,
                                    navManager: MixNavigationManager()
                                ),
                            observeVM: ObserveTracksViewModel(MockData.playlist)
            )
        }
        .environmentObject(PlayerManager())
        .frame(minWidth: 1000)
    }
}
