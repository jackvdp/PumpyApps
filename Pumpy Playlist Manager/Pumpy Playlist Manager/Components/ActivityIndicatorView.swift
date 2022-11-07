//
//  ActivityIndicatorView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 05/03/2022.
//

import Foundation
import SwiftUI
import ActivityIndicatorView
import PumpyAnalytics

struct AppActivityIndicatorView: View {
    
    @Binding var isVisible: Bool
    var frame: CGFloat = 25
    
    var body: some View {
        ActivityIndicatorView(isVisible: $isVisible, type: .growingArc(.pumpyPink))
            .frame(width: frame, height: frame)
            .padding()
    }
    
}
