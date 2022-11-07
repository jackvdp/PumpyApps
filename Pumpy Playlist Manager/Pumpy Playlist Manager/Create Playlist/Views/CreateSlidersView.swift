//
//  CreateSlidersView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 22/06/2022.
//

import SwiftUI
import PumpyAnalytics
import Sliders

struct CreateSlidersView: View {
    
    @Binding var seeding: PlaylistSeeding
    
    let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
        
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
            SliderView(title: "BPM",
                       lowerLabel: "Slow",
                       upperLabel: "Fast",
                       lower: $seeding.seeding.minHappiness,
                       upper: $seeding.seeding.maxHappiness)
        }
        .padding()
    }
    
}

//struct CreateSlidersView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateSlidersView(seeding: .constant(seeding))
//    }
//    
//    static var seeding = CustomSeeding(
//        maxDanceability: 0.5,
//        minDanceability: 0.2,
//        maxEnergy: 0.5,
//        minEnergy: 0.2,
//        maxPopularity: 20,
//        minPopularity: 100,
//        maxBPM: 250,
//        minBPM: 0,
//        maxHappiness: 0.5,
//        minHappiness: 0.2,
//        maxLoudness: 0,
//        minLoudness: -20,
//        maxSpeechiness: 0.5,
//        minSpeechiness: 0.2,
//        maxAcoustic: 0.5,
//        minAcoustic: 0.2
//    )
//}
