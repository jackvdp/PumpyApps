//
//  ContentView.swift
//  GraphQL Test
//
//  Created by Jack Vanderpump on 10/02/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var playerManager: PlayerManager
    @StateObject var windowSizeManager = WindowSizeManager()
    @State private var showPlayer = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:0) {
                MenuView()
                if showPlayer {
                    PlayerView()
                        .transition(.move(edge: .bottom))
                }
            }
            .onChange(of: geo.size) { newValue in
                windowSizeManager.width = geo.size.width
                windowSizeManager.height = geo.size.height
            }
            .onChange(of: playerManager.player) { newValue in
                withAnimation {
                    showPlayer = playerManager.player != nil
                }
            }
            .environmentObject(windowSizeManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class WindowSizeManager: ObservableObject {
    @Published var height: CGFloat = 0
    @Published var width: CGFloat = 0
}
