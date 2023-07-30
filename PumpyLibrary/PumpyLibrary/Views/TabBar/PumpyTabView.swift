//
//  TabBarView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 22/07/2023.
//

import SwiftUI
import Introspect
import PumpyAnalytics

public struct PumpyTabView<H:HomeProtocol,
                    P:PlaylistProtocol,
                    N:NowPlayingProtocol,
                    B:BlockedTracksProtocol,
                    T:TokenProtocol,
                    Q:QueueProtocol,
                    U:UserProtocol>: View {
    
    public init() {}
    
    typealias GenericTabs = Tabs<H,P,N,B,T,Q>
    
    @State private var selectedTab = GenericTabs.home.rawValue
    @Namespace private var animation
    @Namespace private var capsule
    
    public var body: some View {
        tabView
            .overlay(alignment: .bottom) { tabBar }
            .pumpyBackground()
    }
    
    var tabView: some View {
        TabView(selection: $selectedTab) {
            ForEach(GenericTabs.allCases, id: \.rawValue) { tab in
                tab.tag(tab.rawValue).edgesIgnoringSafeArea(.all)
            }
        }
        .introspectTabBarController { setTabAppearance($0) }
    }
    
    var tabBar: some View {
        HStack {
            ForEach(GenericTabs.allCases, id: \.rawValue) { tab in
                Button {
                    withAnimation {
                        selectedTab = tab.rawValue
                    }
                } label: {
                    Image(systemName: tab.icon).overlay(alignment: .bottom) {
                        if selectedTab == tab.rawValue {
                            Capsule()
                                .frame(height: 2)
                                .offset(y: 8)
                                .matchedGeometryEffect(id: capsule, in: animation)
                        }
                    }
                }
                .tint(selectedTab == tab.rawValue ? .pumpyPink : .gray)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(
            Material.bar
        )
    }

    func setTabAppearance(_ tabController: UITabBarController) {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabController.tabBar.scrollEdgeAppearance = appearance
        tabController.tabBar.standardAppearance = appearance
        tabController.viewControllers?.forEach({ vc in
            vc.view.backgroundColor = .clear
        })
    }
}

enum Tabs<H:HomeProtocol,
          P:PlaylistProtocol,
          N:NowPlayingProtocol,
          B:BlockedTracksProtocol,
          T:TokenProtocol,
          Q:QueueProtocol>: Int, CaseIterable, View {
    case home, library, lab, search
    
    var body: some View {
        NavigationView {
            switch self {
            case .home:
                Text(rawValue.description).pumpyBackground()
            case .library:
                PlaylistTable<H,P,N,B,T,Q>()
            case .lab:
                MusicLabView<N,B,T,Q,P,H>()
            case .search:
                SearchView<H,P,N,B,T,Q>()
            }
        }
        .accentColor(.pumpyPink)
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .library:
            return "music.note.list"
        case .lab:
            return "testtube.2"
        }
    }
}

// MARK: - Previews

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing:0) {
            PumpyTabView<MockHomeVM, MockPlaylistManager, MockNowPlayingManager, MockBlockedTracks, MockTokenManager, MockQueueManager, MockUser>()
            MenuTrackView<MockTokenManager, MockNowPlayingManager, MockBlockedTracks, MockPlaylistManager, MockHomeVM>()
        }
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockHomeVM())
        .environmentObject(MusicLabManager())
        .environmentObject(MockTokenManager())
        .environmentObject(AuthorisationManager())
    }
}

