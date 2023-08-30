//
//  TabBarView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 22/07/2023.
//

import SwiftUI
import Introspect
import PumpyAnalytics

public struct PumpyTabView<
    A:AccountManagerProtocol,
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
    public init() {}
    
    typealias GenericTabs = Tabs<A,P,N,B,Q>
    
    @State private var selectedTab = GenericTabs.home.rawValue
    @Namespace private var animation
    @Namespace private var capsule
    @StateObject var tabContainer = TabContainer()
    @EnvironmentObject var labManager: MusicLabManager
    
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
                    if selectedTab == tab.rawValue {
                        let controller = tabContainer.controller
                        let selectedController = controller?.selectedViewController
                        let navController = findFirstNavigationController(in: selectedController)
                        navController?.popToRootViewController(animated: true)
                    } else {
                        withAnimation {
                            selectedTab = tab.rawValue
                        }
                    }
                } label: {
                    Image(systemName: tab.icon)
                        .overlay(alignment: .bottom) {
                            if selectedTab == tab.rawValue {
                                Capsule()
                                    .frame(height: 2)
                                    .offset(y: 8)
                                    .matchedGeometryEffect(id: capsule, in: animation)
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            if tab == .lab, labManager.seedItemsTotal != 0 {
                                Text(labManager.seedItemsTotal.description)
                                    .font(.caption)
                                    .frame(width:12)
                                    .padding(4)
                                    .background(Color.pumpyPink)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .offset(x: 12, y: -12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                }
                .tint(selectedTab == tab.rawValue ? .pumpyPink : .gray)
            }
        }
        .padding()
        .background(Material.bar)
    }

    func setTabAppearance(_ tabController: UITabBarController) {
        tabContainer.controller = tabController
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabController.tabBar.scrollEdgeAppearance = appearance
        tabController.tabBar.standardAppearance = appearance
        tabController.viewControllers?.forEach({ vc in
            vc.view.backgroundColor = .clear
        })
    }
    
    func findFirstNavigationController(in viewController: UIViewController?) -> UINavigationController? {
        guard let viewController else { return nil }
        for childVC in viewController.children {
            if let navigationController = childVC as? UINavigationController {
                return navigationController
            } else {
                if let foundNavController = findFirstNavigationController(in: childVC) {
                    return foundNavController
                }
            }
        }
        return nil
    }
}

class TabContainer: ObservableObject {
    weak var controller: UITabBarController?
}

enum Tabs<
    A:AccountManagerProtocol,
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: Int, CaseIterable, View {
    
    case home, library, lab, search
    
    var body: some View {
        NavigationView {
            switch self {
            case .home:
                HomeView<A,P,N,B,Q>()
            case .library:
                LibraryView<P,N,B,Q>()
            case .lab:
                MusicLabView<N,B,Q,P>()
            case .search:
                SearchView<P,N,B,Q>()
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
    
    static var labManager: MusicLabManager {
        let manager = MusicLabManager()
        manager.selectedGenres.append("Pop")
        manager.addTrack(PumpyAnalytics.MockData.track)
        manager.addTrack(PumpyAnalytics.MockData.track)
        manager.addTrack(PumpyAnalytics.MockData.track)
        manager.addTrack(PumpyAnalytics.MockData.track)
        
        return manager
    }
    
    static var previews: some View {
        VStack(spacing:0) {
            PumpyTabView<
                MockAccountManager,
                MockPlaylistManager,
                MockNowPlayingManager,
                MockBlockedTracks,
                MockQueueManager
            >()
            MenuTrackView<
                MockNowPlayingManager,
                MockBlockedTracks,
                MockPlaylistManager,
                MockHomeVM
            >()
        }
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockNowPlayingManager())
        .environmentObject(MockBlockedTracks())
        .environmentObject(MockPlaylistManager())
        .environmentObject(MockHomeVM())
        .environmentObject(labManager)
        .environmentObject(AuthorisationManager())
        .environmentObject(RecentlyPlayedManager())
    }
}

