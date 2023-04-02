//
//  DualSlider.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/03/2023.
//

import SwiftUI
import PumpyAnalytics
import PumpyShared
import RangeSlider

struct PropertySelector: View {
    @ObservedObject var prop: SeedAttributes
    @State private var showDetails = false
    @EnvironmentObject var labManager: MusicLabManager
    
    var body: some View {
        VStack(alignment: .leading) {
            titleAndActivation
            sliders
            boundaryLabel
            if showDetails && labManager.anyTracksHaveFeatures && prop.active {
                stats
            }
        }
        .font(.callout)
        .accentColor(.pumpyPink)
        .tint(.pumpyPink)
        .toggleStyle(CheckboxStyle())
    }
    
    var titleAndActivation: some View {
        HStack {
            Toggle("", isOn: $prop.active)
            Text(prop.name)
                .bold()
                .opacity(prop.active ? 1 : 0.5)
            Spacer()
            Button {
                showDetails.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .disableAnimation()
            }
            .buttonStyle(.plain)
            .disabled(!labManager.anyTracksHaveFeatures || !prop.active)
        }
    }

    var sliders: some View {
        RangeSlider(lowerValue: $prop.lowerValue,
                    upperValue: $prop.higherValue)
        .disabled(!prop.active)
    }
    
    var boundaryLabel: some View {
        HStack {
            Text(prop.lowerLabel)
            Spacer()
            Text(prop.higherLabel)
        }
        .opacity(prop.active ? 1 : 0.5)
        .font(.subheadline)
    }

}

// MARK: - Previews

struct DualSlider_Previews: PreviewProvider {
    static var previews: some View {
        MockSliders()
    }
    
    struct MockSliders: View {
        var labManager: MusicLabManager = {
            let lm = MusicLabManager()
            lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
            lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
            lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
            lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
            lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
            lm.setAverages()
            return lm
        }()
        
        var body: some View {
            VStack {
                Spacer()
                PropertySelector(prop: labManager.properties[0])
                    .padding()
                    .border(.gray)
                PropertySelector(prop: labManager.properties[1])
                    .padding()
                    .border(.gray)
                PropertySelector(prop: labManager.properties[3])
                    .padding()
                    .border(.gray)
                Spacer()
            }
            .environmentObject(labManager)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .pumpyBackground()
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Drop Down Stats

extension PropertySelector {
    fileprivate var stats: some View {
        VStack(spacing: 8) {
            lowerAndUpperValues
            Divider()
            individualStats
        }
        .font(.subheadline)
        .padding()
        .background(Color.primary.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var lowerAndUpperValues: some View {
        HStack {
            Text("Min: " + prop.actualLowerDescription)
                .bold()
            Spacer()
            Text("Max: " + prop.actualHigherDescription)
                .bold()
        }
    }
    
    private var individualStats: some View {
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
    
    private func propertyName(_ track: PumpyAnalytics.Track) -> String {
        if let keyPath = prop.descriptionKeyPath {
            return track.audioFeatures?[keyPath: keyPath] ?? "–"
        } else {
            return track.spotifyItem?.popularityString ?? "–"
        }
    }
}
