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
            case .search(let searchTerm):
                CatalogSearchView<H,P,N,B,T,Q>(term: searchTerm)
            }
        }
        .navigationTitle("Catalog")
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Playlists, Artists, Songs")
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchText) { newValue in
            if newValue == "" {
                withAnimation {
                    pageState = .complete
                }
            }
        }
    }
    
    // Components
    
    var loadingView: some View {
        ActivityView(activityIndicatorVisible: .constant(true))
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
        ScrollView {
            ForEach(collections, id: \.self) { collection in
                CollectionView<H,P,N,B,T,Q>(collection: collection)
                    .padding(.top)
            }
        }
    }
    
    var failedView: some View {
        Text("Error fetching catalog results. \nPull down to try again.")
            .opacity(0.5)
            .multilineTextAlignment(.center)
            .refreshable {
                getCollections()
            }
    }
    
    // Methods
    
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
        withAnimation {
            pageState = .search(searchText)
        }
    }
    
    enum PageState {
        case loading, complete, search(String)
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
    }
}
