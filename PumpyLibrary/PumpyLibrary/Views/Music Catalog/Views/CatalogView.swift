//
//  CatalogView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 05/09/2022.
//

import SwiftUI
import PumpyAnalytics
import PumpyShared

public struct CatalogView<
    H:HomeProtocol,
    P:PlaylistProtocol,
    N:NowPlayingProtocol,
    B:BlockedTracksProtocol,
    Q:QueueProtocol
>: View {
    
    @EnvironmentObject var authManager: AuthorisationManager
    
    @State var collections = [SuggestedCollection]()
    @UserDefaultsStorage(
        key: "lastCollection",
        defaultValue: Optional<[SuggestedCollection]>.none
    ) var lastCollection
    
    @State var pageState: PageState = .loading
    let browseController = BrowseController()
    
    public init() {}
    
    public var body: some View {
        Group {
            if let lastCollection, collections.isEmpty {
                collectionsView(lastCollection)
            } else {
                switch pageState {
                case .loading:
                    loadingView
                case .catalog:
                    completeView
                }
            }
        }
        .listStyle(.plain)
        .onChange(of: authManager.appleMusicToken) { _ in
            getCollections()
        }
    }
    
    // MARK: - Components
    
    var loadingView: some View {
        ActivityView(activityIndicatorVisible: .constant(true)).noBackground
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    var completeView: some View {
        if collections.isNotEmpty {
            collectionsView(collections)
        } else {
            failedView
        }
    }
    
    func collectionsView(_ collections: [SuggestedCollection]) -> some View {
        ForEach(collections, id: \.self) { collection in
            CollectionView<P,N,B,Q>(collection: collection)
        }
    }
    
    var failedView: some View {
        Text("Error fetching catalog results.\nPull down to try again.")
            .opacity(0.5)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .refreshable {
                getCollections()
            }
            .pumpyBackground()
            .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Methods
    
    func getCollections() {
        pageState = .loading
        browseController.getAppleMusicSuggestions(authManager: authManager) { collection, error in
            if let error {
                print(error.localizedDescription)
            }
            
            collections = collection
            lastCollection = collection
            withAnimation { pageState = .catalog }
        }
    }
        
    enum PageState {
        case loading, catalog
    }
}

struct CatalogView_Previews: PreviewProvider {

    static let authManager = AuthorisationManager()
    
    static var previews: some View {
        NavigationView {
            CatalogView<MockHomeVM,
                        MockPlaylistManager,
                        MockNowPlayingManager,
                        MockBlockedTracks,
                        MockQueueManager>()
        }
        .environmentObject(authManager)
        .preferredColorScheme(.dark)
        NavigationView {
            CatalogView<MockHomeVM,
                        MockPlaylistManager,
                        MockNowPlayingManager,
                        MockBlockedTracks,
                        MockQueueManager>().loadingView
        }
        .environmentObject(authManager)
        .preferredColorScheme(.dark)
    }
}
