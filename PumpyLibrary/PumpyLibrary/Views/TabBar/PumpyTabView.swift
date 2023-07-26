//
//  TabBarView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 22/07/2023.
//

import SwiftUI
import Introspect

struct PumpyTabView: View {
    
    @State private var selectedTab = Tabs.home.rawValue
    @Namespace private var animation
    @Namespace private var capsule
    
    var body: some View {
        tabView
            .overlay(alignment: .bottom) {
                tabBar
            }
            .pumpyBackground()
    }
    
    var tabView: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tabs.allCases, id: \.rawValue) {
                $0
                .tag($0.rawValue)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .introspectTabBarController { setTabAppearance($0) }
    }
    
    var tabBar: some View {
        HStack {
            ForEach(Tabs.allCases, id: \.rawValue) { tab in
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

enum Tabs: Int, CaseIterable, View {
    case home, library, lab, search
    
    var body: some View {
        switch self {
        case .home:
            Text(self.rawValue.description)
        case .library:
            Text(self.rawValue.description)
        case .lab:
            Text(self.rawValue.description)
        case .search:
            Text(self.rawValue.description)
        }
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
            PumpyTabView()
            MenuTrackView<MockTokenManager, MockNowPlayingManager, MockBlockedTracks, MockPlaylistManager, MockHomeVM>()
        }
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockHomeVM())
    }
}
