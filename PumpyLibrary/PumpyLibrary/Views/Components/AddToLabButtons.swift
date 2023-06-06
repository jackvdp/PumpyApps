//
//  AddToLabButtons.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 06/06/2023.
//

import SwiftUI
import PumpyAnalytics

struct LabButtons: View {
    
    @EnvironmentObject var toastManager: ToastManager
    @EnvironmentObject var labManager: MusicLabManager
    @Binding var analysedTrack: PumpyAnalytics.Track?
    
    var body: some View {
        if let analysedTrack, labManager.includes(track: analysedTrack) {
            Button {
                labManager.removeTrack(analysedTrack)
                toastManager.showLabRemoveToast = true
            } label: {
                Label("Remove from Lab", systemImage: "minus")
            }.padding()
        } else {
            Button {
                if let analysedTrack, analysedTrack.audioFeatures != nil {
                    labManager.addTrack(analysedTrack)
                    toastManager.showLabAddToast = true
                } else {
                    toastManager.showLabNotAnalysedToast = true
                }
            } label: {
                Label("Add to Music Lab", systemImage: "plus")
            }.padding()
        }
    }
    
}
