//
//  StatsView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct StatsView: View {
    let title: String
    let artist: String
    let genres: [String]?
    let tempoString: String?
    let pumpyScoreString: String?
    let danceabilityString: String?
    let energyString: String?
    let valenceString: String?
    let loudnessString: String?
    let instrumentalnessString: String?
    let acousticnessString: String?
    let livelinessString: String?
    let popularityString: String?
    let year: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3.weight(.bold))
            Text(artist)
                .font(.title3)
            if let genres = genres?.joined(separator: ", ") {
                Text(genres)
                    .font(.body)
                    .opacity(0.5)
            }
            Divider()
            stats
        }
        .padding()
    }
    
    @ViewBuilder
    var stats: some View {
        Group {
            StatsRow(title: "BPM",
                     value: tempoString ?? "–")
            StatsRow(title: "Peakness",
                     value: pumpyScoreString ?? "–")
            StatsRow(title: "Danceability",
                     value: danceabilityString ?? "–")
            StatsRow(title: "Energy",
                     value: energyString ?? "–")
            StatsRow(title: "Happiness",
                     value: valenceString ?? "–")
        }
        Group {
            StatsRow(title: "Loudness",
                     value: loudnessString ?? "–")
            StatsRow(title: "Instrumentalness",
                     value: instrumentalnessString ?? "–")
        }
        Group {
            StatsRow(title: "Acousticness",
                     value: acousticnessString ?? "–")
            StatsRow(title: "Liveliness",
                     value: livelinessString ?? "–")
        }
        Group {
            StatsRow(title: "Popularity",
                     value: popularityString ?? "–")
            StatsRow(title: "Year",
                     value: year ?? "–")
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    
    static var track = MockData.track
    
    static var previews: some View {
        TrackStatsView(track: MockData.track)
            .frame(width: 200)
    }
}

struct StatsRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack() {
            Text("\(title):")
            Spacer(minLength: 25)
            Text(value)
        }
        .padding(.vertical, 1)
    }
}

