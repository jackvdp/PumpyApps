//
//  CatalogView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 05/09/2022.
//

import SwiftUI
import PumpyAnalytics

public struct CatalogView<H:HomeProtocol,
                          P:PlaylistProtocol,
                          N:NowPlayingProtocol,
                          B:BlockedTracksProtocol,
                          T:TokenProtocol,
                          Q:QueueProtocol>: View {
    
    @EnvironmentObject var authManager: AuthorisationManager
    @State var collections = [SuggestedCollection]()
    @State var pageState: PageState = .loading
    
    public init() {}
    
    public var body: some View {
        VStack {
            switch pageState {
            case .loading:
                loadingView
            case .catalog:
                completeView
            }
        }
        .pumpyBackground()
        .searchToolbar(destination: SearchView<H,P,N,B,T,Q>())
        .labManagerToolbar(destination: MusicLabView<N,B,T,Q,P,H>())
        .navigationTitle("Catalog")
        .listStyle(.plain)
        .onAppear() {
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
            successView
        } else {
            failedView
        }
    }
    
    var successView: some View {
        PumpyList {
            ForEach(collections, id: \.self) { collection in
                CollectionView<H,P,N,B,T,Q>(collection: collection)
            }
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
        BrowseController().getAppleMusicSuggestions(authManager: authManager) { collection, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error fetching results from catalog")
            }
            
            self.collections = collection
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
                        MockTokenManager,
                        MockQueueManager>()
        }
        .environmentObject(authManager)
        .preferredColorScheme(.dark)
        NavigationView {
            CatalogView<MockHomeVM,
                        MockPlaylistManager,
                        MockNowPlayingManager,
                        MockBlockedTracks,
                        MockTokenManager,
                        MockQueueManager>().loadingView
        }
        .environmentObject(authManager)
        .preferredColorScheme(.dark)
    }
}
