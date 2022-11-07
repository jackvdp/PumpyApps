//
//  VolumeControl.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI
import MediaPlayer
import AVKit


struct VolumeControl: View {
    var body: some View {
        HStack(alignment: .center, spacing: 25.0) {
            Image(systemName: "speaker")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .font(Font.title.weight(.light))
                .frame(width: 15, height: 15, alignment: .center)
            VolumeView()
                .frame(height: 20)
            AirPlayView()
                .frame(width: 15, height: 15)
        }
    }
    
    struct VolumeView: UIViewRepresentable {
        
        func makeUIView(context: Context) -> MPVolumeView {
            MPVolumeView(frame: .zero)
        }
        
        func updateUIView(_ view: MPVolumeView, context: Context) {
            view.tintColor = .white
            view.setVolumeThumbImage(UIImage(systemName: "circlebadge.fill"), for: .normal)
            view.showsRouteButton = false
        }
        
    }

    struct AirPlayView: UIViewRepresentable {
        
        func makeUIView(context: Context) -> AVRoutePickerView {
            AVRoutePickerView(frame: .zero)
        }
        
        func updateUIView(_ view: AVRoutePickerView, context: Context) {
            view.tintColor = .white
            view.activeTintColor = UIColor(Color.pumpyPink)
        }
        
    }
}


