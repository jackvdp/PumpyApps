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
    @ObservedObject var prop: SeedAttributes
    
    var body: some View {
        VStack(spacing: 8) {
            lowrAndUpperValues
            Divider()
            individualStats
        }
        .font(.subheadline)
    }
    
    var lowrAndUpperValues: some View {
        HStack {
            Text(prop.transformToSeeding(forMax: false)?.description ?? "–")
            Spacer()
            Text(prop.transformToSeeding(forMax: true)?.description ?? "–")
        }
    }
    
    var individualStats: some View {
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
                Text(propertyName(track))
            }
        }
    }
    
    func propertyName(_ track: PumpyAnalytics.Track) -> String {
        if let keyPath = prop.descriptionKeyPath {
            return track.audioFeatures?[keyPath: keyPath] ?? "–"
        } else {
            return track.spotifyItem?.popularityString ?? "–"
        }
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
        lm.setAverages()
        return lm
    }()
    
    static var previews: some View {
        StatsForFeature(prop: SeedAttributes(name: "Popularity",
                                             lowerLabel: "Playing at bars",
                                             higherLabel: "World Tour",
                                             keyPath: \.energy, descriptionKeyPath: \.energyString))
            .preferredColorScheme(.dark)
            .environmentObject(labManager)
    }
}
