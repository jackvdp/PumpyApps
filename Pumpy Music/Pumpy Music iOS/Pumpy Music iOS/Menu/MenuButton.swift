//
//  MenuButton.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 16/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct MenuButton: View {
    @EnvironmentObject var accountVM: AccountManager
    @EnvironmentObject var user: User
    @EnvironmentObject var musicManager: MusicManager
    @EnvironmentObject var nowPlayingManager: NowPlayingManager
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var extDisMgr: ExternalDisplayManager
    @EnvironmentObject var blockedTracksManager: BlockedTracksManager
    @EnvironmentObject var tokenManager: TokenManager
    @EnvironmentObject var playlistManager: PlaylistManager
    
    var body: some View {
        Button(action: {
                self.homeVM.showMenu = true
        }) {
            Image(systemName: "line.horizontal.3")
                .resizable()
                .foregroundColor(Color.white)
                .frame(width: 25, height: 25, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .font(Font.title.weight(.ultraLight))
        }
        .sheet(isPresented: $homeVM.showMenu) {
            MenuView()
                .environmentObject(user)
                .environmentObject(accountVM)
                .environmentObject(musicManager)
                .environmentObject(nowPlayingManager)
                .environmentObject(playlistManager)
                .environmentObject(settings)
                .environmentObject(homeVM)
                .environmentObject(extDisMgr)
                .environmentObject(blockedTracksManager)
                .environmentObject(tokenManager)
                .environment(\.musicStoreKey, musicManager.tokenManager.appleMusicToken)
                .environment(\.musicStoreFrontKey, musicManager.tokenManager.appleMusicStoreFront)
        }
    }
    
}


struct MediaPicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MPMediaPickerController {
        let controller = MPMediaPickerController(mediaTypes: .music)
            controller.allowsPickingMultipleItems = true
            return controller
    }

    func updateUIViewController(_ uiViewController: MPMediaPickerController, context: Context) {
        
    }
}
