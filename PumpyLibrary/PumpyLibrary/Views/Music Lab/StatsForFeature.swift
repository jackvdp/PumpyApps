//
//  StatsForFeature.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/03/2023.
//

import SwiftUI
import PumpyAnalytics

struct StatsForFeature: View {
    @EnvironmentObject var labManager: MusicLabManager
    var keyPath: KeyPath<PumpyAnalytics.AudioFeatures, String>
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(labManager.seedTracks.indices, id: \.self) { i in
                let track = labManager.seedTracks[i]
                HStack {
                    VStack {
                        Text(track.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(track.artistName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(0.5)
                    }.lineLimit(1)
                    Spacer()
                    Text(track.audioFeatures?[keyPath: keyPath] ?? "–")
                }
            }
        }
        .frame(maxWidth: 250)
    }
}

struct StatsForFeature_Previews: PreviewProvider {
    static var labManager: MusicLabManager = {
        let lm = MusicLabManager()
        lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
        lm.addTrack(PumpyAnalytics.MockData.track)
        lm.addTrack(PumpyAnalytics.MockData.track)
        lm.addTrack(PumpyAnalytics.MockData.track)
        lm.addTrack(PumpyAnalytics.MockData.track)
        lm.addTrack(PumpyAnalytics.MockData.track)
        return lm
    }()
    
    static var previews: some View {
        StatsForFeature(keyPath: \.energyString)
            .preferredColorScheme(.dark)
            .environmentObject(labManager)
    }
}
