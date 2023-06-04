//
//  SearchToolbar.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 29/04/2023.
//

import SwiftUI

struct SearchToolbar<OtherContent: View>: ViewModifier {
    
    var destination: () -> OtherContent
    var modal: Bool
    @State private var showSheet: Bool = false
    @EnvironmentObject var labManager: MusicLabManager
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if modal {
                        Button(action: {
                            showSheet.toggle()
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .padding(.leading)
                        }).buttonStyle(.plain)
                    } else {
                        NavigationLink(destination: destination) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .padding(.leading)
                        }.buttonStyle(.plain)
                    }
                }
            }
            .sheet(isPresented: $showSheet,
                   onDismiss: { labManager.searchViewTriggeredFromLab = false }) {
                NavigationView {
                    destination()
                }
                .tint(.pumpyPink)
                .pumpyBackground()
                .onAppear() {
                    labManager.searchViewTriggeredFromLab = true
                }
            }
    }
}

extension View {
    func searchToolbar<Content: View>(modal: Bool = false, destination: @escaping () -> Content) -> some View {
        self.modifier(SearchToolbar(destination: destination, modal: modal))
    }
}
