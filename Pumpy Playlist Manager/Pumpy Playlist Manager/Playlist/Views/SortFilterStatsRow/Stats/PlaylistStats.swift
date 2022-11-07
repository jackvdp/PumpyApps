//
//  PlaylistStats.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/08/2022.
//

import SwiftUI
import PumpyAnalytics

struct PlaylistStatsButton: View {
    @State private var showStats = false
    @ObservedObject var playlistVM: FilterableViewModel
    @ObservedObject var observeVM: ObserveTracksViewModel
    @State private var isEnabled = false
    
    var body: some View {
        Button {
            showStats.toggle()
        } label: {
            Image(systemName: "chart.bar.xaxis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundColor(isEnabled ? .pumpyPink : .primary.opacity(0.5))
                .animation(.default, value: isEnabled)
        }
        .disabled(!isEnabled)
        .buttonStyle(.plain)
        .popover(isPresented: $showStats) {
            PlaylistStatsView(statsVM: PlaylistStatsViewModel(playlistVM.playlist))
        }
        .onChange(of: observeVM.tracksGettingStats) { newValue in
            withAnimation {
                isEnabled = newValue == 0
            }
        }
    }
}

struct PlaylistStats_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistStatsView(statsVM: PlaylistStatsViewModel(MockData.playlist))
    }
}

struct PlaylistStatsView: View {
    
    @ObservedObject var statsVM: PlaylistStatsViewModel
    
    var body: some View {
        StatsView(title: statsVM.playlist.name ?? "",
                  artist: statsVM.playlist.tracks.count.description + " tracks",
                  genres: statsVM.genres,
                  tempoString: statsVM.tempo,
                  pumpyScoreString: statsVM.peak,
                  danceabilityString: statsVM.dance,
                  energyString: statsVM.energy,
                  valenceString: statsVM.valence,
                  loudnessString: statsVM.loudness,
                  instrumentalnessString: statsVM.instrumentalness,
                  acousticnessString: statsVM.acousticness,
                  livelinessString: statsVM.liveliness,
                  popularityString: statsVM.popularity,
                  year: statsVM.year)
        .onAppear() {
            statsVM.getStats()
        }
    }
    
}
