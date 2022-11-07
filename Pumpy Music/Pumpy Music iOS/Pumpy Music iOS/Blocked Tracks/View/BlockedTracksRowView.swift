//
//  BlockedTracksRowView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

struct BlockedTracksRowView: View {
    
    @StateObject var blockedTrackVM: BlockedTrackViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            Image(uiImage: blockedTrackVM.artwork)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 5.0) {
                HStack(alignment: .center, spacing: 10.0) {
                    Text(blockedTrackVM.trackTitle ?? "Loading...")
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    if blockedTrackVM.isExplicit {
                        Image(systemName: "e.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12, alignment: .center)
                    }
                }
                Text(blockedTrackVM.trackArtist)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            Spacer()
            if blockedTrackVM.trackTitle == nil {
                ActivityView(activityIndicatorVisible: $blockedTrackVM.loadingSpinnerOn, size: 20)
            }
        }
        .padding(.all, 5.0)
    }
}

struct BlockedTracksRowView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedTracksRowView(blockedTrackVM: BlockedTrackViewModel(BlockedTrack(isExplicit: false, playbackID: ""), token: "", storeFront: ""))
        BlockedTracksRowView(
            blockedTrackVM:
                BlockedTrackViewModel(
                    BlockedTrack(title: "Test",
                                 artist: "Test",
                                 isExplicit: true,
                                 playbackID: "n4fjrhfn"),
                    token: "",
                    storeFront: "")
        )
    }
}
