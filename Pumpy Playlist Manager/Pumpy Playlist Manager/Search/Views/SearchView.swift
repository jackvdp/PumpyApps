//
//  SYBPlaylistView.swift
//  GraphQL Test
//
//  Created by Jack Vanderpump on 10/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct SearchView: View {
    
    @ObservedObject var searchVM: SearchResultsViewModel
    @ObservedObject var navigatior: SearchNavigationManager
    @EnvironmentObject var authManager: AuthorisationManager

    var body: some View {
        VStack {
            Header(navManager: navigatior)
            Spacer(minLength: 0)
            switch navigatior.currentPage {
            case .search:
                SearchProvidersView(searchVM: searchVM,
                                    navigator: navigatior)
            case .playlist(let playlist):
                GetPlaylistView(playlist, authManager: authManager)
            }
            Spacer(minLength: 0)
        }
        .animation(.default, value: navigatior.currentPage)
        .alert(searchVM.errorMessage.title,
               isPresented: $searchVM.showError) {
            Button("OK") {}
        } message: {
            Text(searchVM.errorMessage.message)
        }
    }
}

struct SYBPlaylistView_Previews: PreviewProvider {

    static var previews: some View {
        SearchView(searchVM: SearchResultsViewModel(), navigatior: SearchNavigationManager())
    }
}
