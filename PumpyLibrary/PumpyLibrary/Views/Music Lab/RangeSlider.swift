//
//  RangeSlider.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 14/03/2023.
//

import SwiftUI

struct RangeSlider: View {
    
    @Binding var lowerValue: Double
    @Binding var upperValue: Double
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer(minLength: 0)
                ZStack {
                    HStack(spacing: 0) {
                        componentSlider
                            .foregroundColor(.primary.opacity(0.1))
                            .frame(width: lowerValue * geo.size.width)
                        componentSlider
                            .foregroundColor(.accentColor)
                            .frame(width: (upperValue - lowerValue) * geo.size.width)
                        componentSlider
                            .foregroundColor(.primary.opacity(0.1))
                            .frame(width: (1-upperValue) * geo.size.width)
                    }
                    .cornerRadius(2)
                    thumb.offset(x: (lowerValue - 0.5) * geo.size.width)
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    respondToGesture(changingUpperValue: false,
                                                     gesture: gesture, geo: geo)
                                }
                        )
                    thumb.offset(x: (upperValue - 0.5) * geo.size.width)
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    respondToGesture(changingUpperValue: true,
                                                     gesture: gesture, geo: geo)
                                }
                        )
                }
                Spacer(minLength: 0)
            }
        }
        .frame(height: 30, alignment: .center)
    }
    
    private var componentSlider: some View {
        Rectangle()
            .frame(height: 4)
    }
    
    private var thumb: some View {
        Image(systemName: "circle.fill")
            .resizable()
            .foregroundColor(.white)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 4, y: 2)
            .frame(width: 25, height: 25)
    }
    
    private func respondToGesture(changingUpperValue: Bool, gesture: DragGesture.Value, geo: GeometryProxy) {
        let percentageOfSlider = gesture.location.x / geo.size.width + 0.5
        var valueChanging = changingUpperValue ? upperValue : lowerValue
        valueChanging = max(min(percentageOfSlider, 1), 0)
        
        if changingUpperValue {
            upperValue = valueChanging
        } else {
            lowerValue = valueChanging
        }

        if changingUpperValue {
            if upperValue < lowerValue {
                lowerValue = upperValue
            }
        } else {
            if lowerValue > upperValue {
                upperValue = lowerValue
            }
        }
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RangeSlider(lowerValue: .constant(0.33), upperValue: .constant(0.66))
                .accentColor(.pumpyPink)
                .padding(40)
        }
    }
}
