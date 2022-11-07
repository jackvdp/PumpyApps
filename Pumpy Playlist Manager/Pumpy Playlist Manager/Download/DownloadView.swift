//
//  DownloadView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 26/03/2022.
//

import SwiftUI
import ToastUI
import PumpyAnalytics

struct DownloadView: View {
    
    @EnvironmentObject var windowSizeManager: WindowSizeManager
    @ObservedObject var downloadVM: DownloadViewModel
    @ObservedObject var observeVM: ObserveTracksViewModel
    @Binding var showingSheet: Bool
    @State private var readyToMix = false
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            playlistName
            matchedTracks
            if (downloadVM.unMatchedTracks.count != 0) {
                unmatchedTracks
            }
            progressBarAndButtons
        }
        .padding()
        .onReceive(observeVM.$tracksMatching) { newValue in
            withAnimation {
                readyToMix = newValue == 0
            }
        }
        .alert(downloadVM.alertMessage, isPresented: $downloadVM.showAlert) {}
        .frame(minWidth: windowSizeManager.width * 0.9,
               minHeight: windowSizeManager.height * 0.9)
    }
    
    @ViewBuilder
    var header: some View {
        Text("Convert Playlist")
            .font(.title)
        Divider()
    }
    
    var playlistName: some View {
        HStack {
            Text("Playlist name:")
            TextField("Playlist name", text: $downloadVM.playlistName)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 600)
        }
        .padding(.bottom, 25)
    }
    
    @ViewBuilder
    var matchedTracks: some View {
        Text("Matched: \(downloadVM.matchedTracks.count) tracks")
        TracksView(tracks: downloadVM.matchedTracks,
                   deleteAction: nil,
                   columnsShowing: ColumnsShowing())
    }
    
    @ViewBuilder
    var unmatchedTracks: some View {
        Text("Unmatched : \(downloadVM.unMatchedTracks.count) tracks")
        TracksView(tracks: downloadVM.unMatchedTracks,
                   deleteAction: nil,
                   columnsShowing: ColumnsShowing())
    }
    
    var progressBarAndButtons: some View {
        HStack(spacing: 20) {
            ProgressView()
                .opacity(downloadVM.converting ? 1 : 0)
                .progressViewStyle(.linear)
            Spacer()
            Button("Cancel") {
                showingSheet = false
            }
            Button(readyToMix ? "Convert" : "Matching...") {
                downloadVM.downloadPlaylist() {
                    showingSheet = false
                }
            }
//            .disabled(!readyToMix)
            .keyboardShortcut(.defaultAction)
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView(downloadVM: DownloadViewModel(playlistName: "Test", tracks: MockData.tracks,
                                                   authManager: AuthorisationManager()),
                     observeVM: ObserveTracksViewModel(MockData.playlist),
                     showingSheet: .constant(true))
    }
}
