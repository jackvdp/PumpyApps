//
//  DislikedTracksView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

struct BlockedTracksView: View {
    
    @EnvironmentObject var blockedTracksManager: BlockedTracksManager
    let token: String
    let storeFront: String
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            if blockedTracksManager.blockedTracks.isEmpty {
                Text("No Blocked Tracks")
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)
            } else {
                List {
                    ForEach(blockedTracksManager.blockedTracks, id: \.self) { track in
                        BlockedTracksRowView(blockedTrackVM: BlockedTrackViewModel(track,
                                                                                   token: token,
                                                                                   storeFront: storeFront))
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .navigationBarItems(trailing: Button(action: {
                    showAlert = true
                }, label: {
                    Text("Reset")
                }))
            }
        }
        .navigationBarTitle("Blocked Tracks")
        .alert(isPresented: $showAlert) {
            createAlert()
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            if let item = blockedTracksManager.blockedTracks[safe: i] {
                blockedTracksManager.removeTrack(id: item.playbackID)
            }
        }
    }
    
    func createAlert() -> Alert {
        return Alert(title: Text("Unblock all tracks?"),
                          message: Text("All tracks will be remove from blocked list and will return to scheduled playback."),
                          primaryButton: .destructive(Text("Cancel"), action: {}),
                          secondaryButton: .default(Text("Unblock"), action: { blockedTracksManager.blockedTracks = [] }))
    }
}


#if DEBUG
struct BlockedTracksView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedTracksView(token: "", storeFront: "")
            .environmentObject(MockBlockedTracks())
    }
}
#endif
