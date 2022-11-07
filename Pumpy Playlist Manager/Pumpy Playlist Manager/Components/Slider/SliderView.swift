//
//  SliderView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 23/06/2022.
//

import SwiftUI

struct SliderView: View {
    let title: String
    let lowerLabel: String
    let upperLabel: String
    @Binding var lower: Double
    @Binding var upper: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.callout)
            Slider(lower: $lower, upper: $upper)
            HStack {
                Text(lowerLabel)
                    .font(.caption2)
                    .opacity(0.5)
                Spacer()
                Text(upperLabel)
                    .font(.caption)
                    .opacity(0.5)
            }
            
        }
        
        .padding(10)
        .background(.ultraThickMaterial)
        .cornerRadius(10)
        .frame(width: 150)
    }
    
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView(
            title: "BPM",
            lowerLabel: "Slow",
            upperLabel: "Fast",
            lower: .constant(0.2),
            upper: .constant(1)
        )
        .padding()
        SliderView(
            title: "BPM",
            lowerLabel: "Slow",
            upperLabel: "Fast",
            lower: .constant(0.2),
            upper: .constant(1)
        )
        .padding()
        .preferredColorScheme(.dark)
    }
}
