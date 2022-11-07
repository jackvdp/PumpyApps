//
//  Slider.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 23/06/2022.
//

import SwiftUI
import Sliders

extension SliderView {
    struct Slider: View {
        @Binding var lower: Double
        @Binding var upper: Double
        
        var range: Binding<ClosedRange<Double>>{
            Binding<ClosedRange<Double>>(get: {
                return ClosedRange(uncheckedBounds: (lower, upper))
            }, set: {
                lower = $0.lowerBound
                upper = $0.upperBound
            })
        }
        
        var body: some View {
            RangeSlider(range: range)
                .rangeSliderStyle(
                        HorizontalRangeSliderStyle(
                            lowerThumbSize: CGSize(width: 10, height: 10),
                            upperThumbSize: CGSize(width: 10, height: 10),
                            options: .forceAdjacentValue
                        )
                    )
                .frame(height: 20)
        }
    }
}
