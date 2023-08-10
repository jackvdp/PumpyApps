//
//  AddToLibraryView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2023.
//

import SwiftUI
import PumpyAnalytics

struct AddToLibraryView<P: PlaylistProtocol>: View {
    
    var playlist: Playlist
    @State private var showAddToLibraryAlert = false
    @EnvironmentObject var libraryManager: LibraryManager
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var authManager: AuthorisationManager
    @EnvironmentObject var toastManager: ToastManager
    
    var inLibrary: Bool {
        libraryManager.isPlaylistInLibrary(playlist, playlistManager: playlistManager)
    }
    
    var body: some View {
        Group {
            if libraryManager.playlistsCurrentlyConverting.contains(playlist.sourceID) {
                ProgressView()
            } else {
                Button(action: {
                    if !inLibrary {
                        libraryManager.addToLibrary(playlist, authManager: authManager, toastManager: toastManager)
                    }
                }, label: {
                    Image(systemName: inLibrary ? "checkmark" : "plus" )
                })
                .foregroundColor(.white)
                .buttonStyle(.plain)
                .alert(isPresented: $showAddToLibraryAlert) {
                    Alert(
                        title: Text("Add to Library?"),
                        message: Text("Add to your Apple Music Library?"),
                        primaryButton: .default(Text("Add")),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .padding(.leading)
    }
}

struct AddToLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        AddToLibraryView<MockPlaylistManager>(playlist: MockData.playlist)
            .environmentObject(MockPlaylistManager())
            .environmentObject(LibraryManager())
    }
}
