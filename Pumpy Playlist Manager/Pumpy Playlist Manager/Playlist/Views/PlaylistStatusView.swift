//
//  StatsStatusView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/05/2022.
//

import SwiftUI
import PumpyAnalytics

struct PlaylistStatusView: View {
    
    @ObservedObject var viewModel: ObserveTracksViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            StatusView(
                label: "Matched to Apple Music",
                recieved: viewModel.tracksMatched,
                failed: viewModel.tracksNotMatched,
                inProgress: viewModel.tracksMatching,
                total: viewModel.playlist.tracks.count)
            StatusView(
                label: "Analysed",
                recieved: viewModel.tracksWithStats,
                failed: viewModel.tracksWithOutStats,
                inProgress: viewModel.tracksGettingStats,
                total: viewModel.playlist.tracks.count)
            reloadButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var reloadButton: some View {
        Button {
            viewModel.manualUpdate()
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .buttonStyle(.plain)
        .opacity(0.5)
        .font(.caption2)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
}

struct StatsStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistStatusView(
            viewModel: ObserveTracksViewModel(MockData.playlist)
        )
    }
}
