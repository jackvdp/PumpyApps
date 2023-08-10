//
//  ToastManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/04/2023.
//

import SwiftUI
import AlertToast

public class ToastManager: ObservableObject {
    
    public init() {}
    
    @Published var showingPlayNextToast = false
    @Published var showLabAddToast = false
    @Published var showLabRemoveToast = false
    @Published var showLabNotAnalysedToast = false
    @Published var showLibraryAddedToast = false
    @Published var showLibraryAddedErrorToast = false
    
}

extension View {
    public func musicToasts() -> some View {
        modifier(MusicToasts())
    }
}

struct MusicToasts: ViewModifier {
    
    @EnvironmentObject var toastManager: ToastManager
    
    func body(content: Content) -> some View {
        content
            .toast(isPresenting: $toastManager.showingPlayNextToast) {
                playNextToast
            }
            .toast(isPresenting: $toastManager.showLabAddToast) {
                labAddToast
            }
            .toast(isPresenting: $toastManager.showLabRemoveToast) {
                labRemoveToast
            }
            .toast(isPresenting: $toastManager.showLabNotAnalysedToast) {
                labNotAnalsyedToast
            }
            .toast(isPresenting: $toastManager.showLibraryAddedToast) {
                libraryAddToast
            }
            .toast(isPresenting: $toastManager.showLibraryAddedErrorToast) {
                libraryErrorToast
            }
    }
    
    var playNextToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("plus", .pumpyPink),
                   title: "Playing Next")
    }
    
    var labAddToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("plus", .pumpyPink),
                   title: "Added to Music Lab")
    }
    
    var labRemoveToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("minus", .pumpyPink),
                   title: "Removed from Music Lab")
    }
    
    var labNotAnalsyedToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("exclamationmark.triangle", .pumpyPink),
                   title: "Not analysed",
                   subTitle: "Try again.")
    }
    
    var libraryAddToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("plus", .pumpyPink),
                   title: "Added to Library")
    }
    
    var libraryErrorToast: AlertToast {
        AlertToast(displayMode: .alert,
                   type: .systemImage("exclamationmark.triangle", .pumpyPink),
                   title: "Item not added to library",
                   subTitle: "Try again.")
    }
    
}
