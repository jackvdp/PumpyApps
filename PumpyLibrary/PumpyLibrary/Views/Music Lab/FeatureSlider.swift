//
//  DualSlider.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/03/2023.
//

import SwiftUI
import PumpyAnalytics

struct FeatureSlider: View {
    @Binding var prop: SeedAttributes
    @State private var showDetails = false
    @EnvironmentObject var labManager: MusicLabManager
    
    var body: some View {
        VStack(alignment: .leading) {
            titleAndActivation
            sliders
            boundaryLabel
            if showDetails && labManager.anyTracksHaveFeatures {
                Divider().padding()
                StatsForFeature(keyPath: prop.keyPath)
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
            Text(prop.name).bold()
                .opacity(prop.active ? 1 : 0.5)
            Spacer()
            Button {
                showDetails.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .frame(width: 20, height: 20)
            }.buttonStyle(.plain)
                .disabled(!labManager.anyTracksHaveFeatures)

        }
    }

    var sliders: some View {
        HStack(spacing: -4) {
            Slider(value: $prop.lowerValue,
                   in: 0...50,
                   step: 1)
                .rotationEffect(.degrees(180))
                .offset(y: 1)
            Slider(value: $prop.higherValue,
                   in: 0...50,
                   step: 1)
        }
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
        @State var prop = SeedAttributes(name: "Popularity",
                                         lowerLabel: "Playing at bars",
                                         higherLabel: "World Tour",
                                         keyPath: \.energyString)
        
        var body: some View {
            VStack {
                Spacer()
                FeatureSlider(prop: $prop)
                    .padding()
                    .border(.gray)
                Spacer()
                Divider()
                Text("Lower: \(prop.lowerValue.description)")
                Text("Upper: \(prop.higherValue.description)")
                Spacer()
            }
            .environmentObject(MusicLabManager())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .pumpyBackground()
            .preferredColorScheme(.dark)
        }
    }
}
