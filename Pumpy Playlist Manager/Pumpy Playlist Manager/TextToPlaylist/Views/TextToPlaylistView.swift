//
//  TextToPlaylistView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 30/10/2022.
//

import SwiftUI
import PumpyAnalytics

struct TextToPlaylistView: View {
    
    @EnvironmentObject var authManager: AuthorisationManager
    @EnvironmentObject var navManager: TextNavigationManager
    @StateObject var viewModel = TextToPlaylistViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                textField
                    .frame(height: geo.size.height / 3 - 25)
                Divider()
                    .frame(height: 20)
                bottomContent
                    .frame(height: geo.size.height * 2 / 3 - 25)
                bottomButton
            }
        }
        .padding()
        .onChange(of: viewModel.inputedText) { newValue in
            viewModel.convertTextToTracks(authManager: authManager)
        }
    }
    
    var bottomButton: some View {
        Button("Create") {
            let playlist = viewModel.createPlaylist(authManager: authManager)
            navManager.currentPage = .playlist(playlist)
        }
        .keyboardShortcut(.return)
        .buttonStyle(.bordered)
        .frame(height: 30)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(viewModel.tracksDictionary.isEmpty)
    }
        
    var textField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Playlist Text (seperate each track with a new line):")
                .opacity(0.5)
            TextEditor(text: $viewModel.inputedText)
                .padding(10)
                .border(.background, width: 10)
                .border(.tertiary)
        }
    }
    
    @ViewBuilder
    var bottomContent: some View {
        if viewModel.tracksDictionary.isEmpty {
            Text("Enter list of tracks above!")
                .frame(maxWidth: .infinity)
                .font(.title.bold())
                .opacity(0.5)
        } else {
            tracksTable
        }
    }
    
    var tracksTable: some View {
        List {
            Section(header: tableHeader, content: {
                ForEach(viewModel.tracksDictionary, id: \.0.self) { trackPair in
                    HStack {
                        Text(trackPair.0)
                            .lineLimit(2)
                            .frame(width: 300, alignment: .leading)
                        Spacer()
                        if let track = trackPair.1 {
                            TracksTitleContent(track: track)
                                
                        }
                    }
                }
            })
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
    }
    
    var tableHeader: some View {
        HStack {
            Text("Track Text")
                .bold()
                .frame(width: 300, alignment: .leading)
            Text("Matched Track")
                .bold()
        }
    }
}

struct TextToPlaylistView_Previews: PreviewProvider {
    
    static var viewModel: TextToPlaylistViewModel {
        let vm = TextToPlaylistViewModel()
        vm.inputedText =
    """
    Dancing in the street - Martha Reeves and the Vandellas
    Do you love me - the contours
    how will i know - whitney houston
    i wanna dance with somebody - whitney houston
    all night long  - lionel richie
    """
        
        vm.tracksDictionary = [("Dancing in the street - Martha Reeves and the Vandellas", MockData.track),
                               ("Do you love me - the contours", MockData.track),
                               ("how will i know - whitney houston", nil)]
        return vm
    }
    
    static var previews: some View {
        Group {
            TextToPlaylistView(viewModel: viewModel)
                .preferredColorScheme(.light)
            TextToPlaylistView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(AuthorisationManager())
        .environmentObject(PlayerManager())
    }
}
