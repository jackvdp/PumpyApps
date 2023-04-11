//
//  LabaManagerToolbar.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/04/2023.
//

import Foundation
import SwiftUI

struct LabManagerToolbar<OtherContent: View>: ViewModifier {
    
    @EnvironmentObject var labManager: MusicLabManager
    var destination: OtherContent
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if labManager.seedTracks.isNotEmpty {
                        NavigationLink(destination: destination) {
                            Image(systemName: "testtube.2").resizable()
                        }.buttonStyle(.plain)
                    }
                }
            }
    }
}

extension View {
    func labManagerToolbar<Content: View>(destination: Content) -> some View {
        self.modifier(LabManagerToolbar(destination: destination))
    }
}
