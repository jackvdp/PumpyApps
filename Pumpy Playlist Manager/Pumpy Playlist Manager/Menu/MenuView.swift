//
//  HomeView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 14/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct MenuView: View {
    
    @State private var selection: Int? = 1
    @EnvironmentObject var authManager: AuthorisationManager
    @EnvironmentObject var createManager: CreateManager
    @StateObject var libNavManager = LibrariesNavigationManager()
    @StateObject var savedNavManager = SavedNavigationManager()
    @StateObject var mixNavManager = MixNavigationManager()
    @StateObject var createNavManager = CreateNavigationManager()
    
    var body: some View {
        NavigationView {
            VStack {
                MenuSearchView()
                    .padding(.top, 2)
                Divider()
                    .padding(.horizontal)
                List(selection: $selection) {
                    MenuItem(destination: LibrariesView(navManager: libNavManager),
                             label: "Libraries",
                             image: "house.fill")
                        .tag(1)
                    MenuItem(destination: EmptyView(),
                             label: "Browse",
                             image: "square.stack")
                        .tag(2)
                    MenuItem(destination: SavedView(navManager: savedNavManager),
                             label: "Saved Playlists",
                             image: "music.note.list")
                        .tag(3)
                    MenuItem(destination: MixView(navManager: mixNavManager),
                             label: "Playlist Mixer",
                             image: "shuffle")
                        .tag(4)
                        .badge(createManager.playlistsToMegre.count > 0 ? "\(createManager.playlistsToMegre.count)" : nil)
                    MenuItem(destination: CreateView(navManager: createNavManager),
                             label: "Create Playlist",
                             image: "star.fill")
                        .tag(5)
                        .badge(createManager.tracksToCreate.count > 0 ? "\(createManager.tracksToCreate.count)" : nil)
                    MenuItem(destination: TextPlaylistView(),
                             label: "Text Converter",
                             image: "text.quote")
                        .tag(9)
                }
                Spacer()
                List(selection: $selection) {
                    MenuItem(destination: EmptyView(),
                             label: "Help",
                             image: "questionmark.circle")
                        .tag(6)
                    MenuItem(destination: EmptyView(),
                             label: "Settings",
                             image: "gear")
                        .tag(7)
                    MenuItem(destination: AccountsView(),
                             label: "Accounts",
                             image: "person.fill")
                        .tag(8)
                }
                .frame(height: 150, alignment: .bottom)
            }
            .frame(minWidth: 250)
            .animation(.default, value: selection)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    
    static let authManager = AuthorisationManager()
    static var previews: some View {
        MenuView()
            .frame(height: 600)
            .environmentObject(PlayerManager())
            .environmentObject(AccountManager())
            .environmentObject(SavedPlaylistController())
            .environmentObject(authManager)
            .environmentObject(LibrariesManager())
    }
}
