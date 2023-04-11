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
    @StateObject private var viewModel = CatalogSearchViewModel()
    @State var collections = [SuggestedCollection]()
    @State var pageState: PageState = .loading
    @State private var searchText = ""
    
    public init() {}
    
    public var body: some View {
        VStack {
            switch pageState {
            case .loading:
                loadingView
                    .onAppear() {
                        getCollections()
                    }
            case .complete:
                completeView
            case .search:
                CatalogSearchView<H,P,N,B,T,Q>(viewModel: viewModel)
            }
        }
        .pumpyBackground()
        .labManagerToolbar(destination: MusicLabView<N,B,T,Q,P,H>())
        .navigationTitle("Catalog")
        .listStyle(.plain)
        .searchable(text: $searchText,
                    prompt: "Playlists, Artists, Songs")
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchText) { newValue in
            if newValue == "" {
                withAnimation {
                    pageState = .complete
                }
            }
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
            .background(ArtworkView().background)
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
            withAnimation { pageState = .complete }
        }
    }
    
    func runSearch() {
        viewModel.pageState = .loading
        viewModel.runSearch(term: searchText, authManager: authManager)
        withAnimation {
            pageState = .search
        }
    }
    
    enum PageState {
        case loading, complete, search
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
