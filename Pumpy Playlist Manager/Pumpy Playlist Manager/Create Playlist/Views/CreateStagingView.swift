//
//  CreateStagingView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct CreateStagingView: View {
    
    @EnvironmentObject var createManager: CreateManager
    @EnvironmentObject var authManager: AuthorisationManager
    @StateObject var createVM: CreateStagingViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                CreateTracksView(createVM: createVM,
                                 height: geo.size.height / 2)
                    .border(.foreground, width: 2)
                Divider()
                ScrollView {
                    CreateSlidersView(seeding: $createVM.seeding)
                }
                .frame(height: geo.size.height / 3, alignment: .top)
                Spacer(minLength: 0)
                if !createManager.tracksToCreate.isEmpty {
                    button
                        .frame(width: 300, height: geo.size.height / 6)
                }
            }
        }
    }
    
    var button: some View {
        Button(action: {
            createVM.makeRequest(authManager: authManager, tracks: createManager.tracksToCreate)
        }, label: {
            Text("Create")
                .frame(width: 300)
        })
        .buttonStyle(GrowingButton())
        .padding()
    }
}

struct CreateStagingView_Previews: PreviewProvider {

    static let createManager = CreateManager()

    static var previews: some View {
        CreateStagingView(
            createVM:
                CreateStagingViewModel(
                    nav: CreateNavigationManager()))
            .environmentObject(createManager)
            .environmentObject(PlayerManager())
            .onAppear() {
                createManager.tracksToCreate.append(MockData.track)
            }
            .frame(minWidth: 500, minHeight: 500, alignment: .top)
    }
}
