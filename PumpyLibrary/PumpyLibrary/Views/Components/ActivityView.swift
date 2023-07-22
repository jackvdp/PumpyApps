//
//  ActivityView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 22/07/2023.
//

import SwiftUI
import ActivityIndicatorView

public struct ActivityView: View {
    @Binding var activityIndicatorVisible: Bool
    let size: Double
    
    public init(activityIndicatorVisible: Binding<Bool>, size: Double = 50.0) {
        self._activityIndicatorVisible = activityIndicatorVisible
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .opacity(0.5)
                .isHidden(!activityIndicatorVisible)
            noBackground
        }
    }
    
    public var noBackground: some View {
        ActivityIndicatorView(isVisible: $activityIndicatorVisible, type: .arcs())
            .frame(width: size, height: size)
            .foregroundColor(Color.pumpyPink)
    }
}
