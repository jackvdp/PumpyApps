//
//  SliderVAlueView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 23/06/2022.
//

import SwiftUI

struct SliderValueView: View {
    let value: Double
    
    var body: some View {
        if value <= 1 {
            Text("\(Int(value * 100))%")
                .font(.callout)
                .frame(width: 30)
        } else {
            Text("\(Int(value))")
                .font(.callout)
                .frame(width: 30)
        }
    }
}

struct SliderVAlueView_Previews: PreviewProvider {
    static var previews: some View {
        SliderValueView(value: 1)
        SliderValueView(value: 120)
    }
}
