//
//  DualSlider.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/03/2023.
//

import SwiftUI
import Introspect

struct DualSlider: View {
    @Binding var lowerValue: Double
    @Binding var upperValue: Double
    @Binding var active: Bool
    let titleLable: String
    let lowerLabel: String
    let higherLabel: String
    
    var body: some View {
        VStack(alignment: .leading) {
            titleAndActivation
            sliders
            boundaryLabel
        }
        .font(.callout)
        .accentColor(.pumpyPink)
        .tint(.pumpyPink)
        .toggleStyle(CheckboxStyle())
    }
    
    var titleAndActivation: some View {
        HStack {
            Text(titleLable).bold()
                .opacity(active ? 1 : 0.5)
            Spacer()
            Toggle("", isOn: $active)
        }
    }

    var sliders: some View {
        HStack(spacing: -4) {
            Slider(value: $lowerValue,
                   in: 0...50,
                   step: 1)
                .rotationEffect(.degrees(180))
                .offset(y: 1)
            Slider(value: $upperValue,
                   in: 0...50,
                   step: 1)
        }
        .disabled(!active)
    }
    
    var boundaryLabel: some View {
        HStack {
            Text(lowerLabel)
            Spacer()
            Text(higherLabel)
        }
        .opacity(active ? 0.5 : 0.2)
    }

}

// MARK: - Previews

struct DualSlider_Previews: PreviewProvider {
    static var previews: some View {
        MockSliders()
    }
    
    struct MockSliders: View {
        @State var lower: Double = 25
        @State var upper: Double = 25
        @State var active = true
        
        var body: some View {
            VStack {
                Spacer()
                DualSlider(lowerValue: $lower,
                           upperValue: $upper,
                           active: $active,
                           titleLable: "Popularity",
                           lowerLabel: "Playing at bars",
                           higherLabel: "World Tour")
                .padding()
                .border(.gray)
                Spacer()
                Divider()
                Text("Lower: \(lower.description)")
                Text("Upper: \(upper.description)")
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .pumpyBackground()
            .preferredColorScheme(.dark)
        }
    }
}
