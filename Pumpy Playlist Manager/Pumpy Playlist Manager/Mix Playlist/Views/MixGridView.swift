//
//  MergeView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct MixGridView: View {
    
    @EnvironmentObject var createManager: CreateManager
    @ObservedObject var gridVM: MixGridViewModel
    var body: some View {
        if createManager.playlistsToMegre.isEmpty {
            VStack {
                Text("Add Playlists to Mix")
                    .font(.title)
                    .opacity(0.5)
            }
        } else {
            ZStack(alignment: .bottom) {
                ReusableGridView(gridVM: gridVM, playlists: createManager.playlistsToMegre)
                if !createManager.playlistsToMegre.isEmpty {
                    Button(action: {
                        gridVM.mixPlaylists(createManager.playlistsToMegre)
                    }, label: {
                        Text("Mix")
                            .frame(width: 300)
                    })
                    .buttonStyle(GrowingButton())
                    .padding()
                }
            }
            .onTapGesture {
                gridVM.unSelectAllItems()
            }
        }
    }
}

struct MergeView_Previews: PreviewProvider {
    static let create = CreateManager()
    static var previews: some View {
        MixGridView(gridVM: MixGridViewModel(navigator: MixNavigationManager()))
            .environmentObject(create)
            .environmentObject(SavedPlaylistController())
            .onAppear() {
                create.playlistsToMegre.append(MockData.snapshot)
            }
    }
}
