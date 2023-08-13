//
//  MoreInfoButton.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 13/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct MoreInfoButton: View {
    
    @State private var showPopup = false
    @ObservedObject var track: PumpyAnalytics.Track
    
    var body: some View {
        Button(action: {
            showPopup = true
        }) {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .popup(isPresented: $showPopup) {
            VStack {
                TrackPreview(track: track)
                LabButtons(analysedTrack: track)
                    .buttonStyle(.bordered)
                    .tint(.pumpyPink)
            }
            .padding()
            .background(.black.opacity(0.6))
            .cornerRadius(16)
        } customize: { popup in
            popup
                .type(.default)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .backgroundView {
                    Rectangle().foregroundStyle(Material.regular)
                }
        }
    }
    
}


struct MoreInfoButton_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoButton(track: PumpyAnalytics.MockData.trackWithFeatures)
    }
}
