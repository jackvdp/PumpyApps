//
//  CreateTracksView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 23/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct CreateTracksView: View {
    
    @ObservedObject var createVM: CreateStagingViewModel
    @EnvironmentObject var createManager: CreateManager
    let height: CGFloat
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(createManager.tracksToCreate) { track in
                    GeometryReader { geo in
                        CreateTrackView(
                            track: track,
                            height: geo.size.width
                        )
                    }
                }
                .frame(height: height)
                ForEach(0..<(5 - createManager.tracksToCreate.count), id:\.self) { blank in
                    GeometryReader { geo in
                        CreateBlankView(
                            number: blank + createManager.tracksToCreate.count + 1,
                            width: geo.size.width)
                    }
                }
                .frame(height: height)
            }
            .border(.red, width: 2)
        }
        .border(.blue, width: 2)
    }
}

struct CreateTracksView_Previews: PreviewProvider {
    static var createVM: CreateManager {
        let cm = CreateManager()
        cm.tracksToCreate = [MockData.track]
        return cm
    }
    
    static var previews: some View {
        CreateTracksView(createVM: CreateStagingViewModel(
            nav: CreateNavigationManager()), height: 200)
        .frame(width: 400, height: 400, alignment: .center)
        .environmentObject(createVM)
        .environmentObject(PlayerManager())
    }
}
