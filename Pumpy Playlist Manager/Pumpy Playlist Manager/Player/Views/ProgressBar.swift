//
//  ProgressBar.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct ProgressBar: View {
    
    var currentTime: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 2)
                    .background(.white)
                Rectangle()
                    .frame(width: geo.size.width * currentTime, height: 2)
                    .foregroundColor(Color.pumpyPink)
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(currentTime: 0.5)
    }
}
