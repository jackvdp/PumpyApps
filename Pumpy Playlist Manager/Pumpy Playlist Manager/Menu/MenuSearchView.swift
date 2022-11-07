//
//  MenuSearchView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 29/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct MenuSearchView: View {
    
    @StateObject var menuSearchVM = MenuSearchViewModel()
    @StateObject var searchResultsVM = SearchResultsViewModel()
    @StateObject var navigatior = SearchNavigationManager()
    @EnvironmentObject var authManager: AuthorisationManager
    
    var body: some View {
        NavigationLink(destination: SearchView(searchVM: searchResultsVM, navigatior: navigatior),
                       isActive: $menuSearchVM.showSearchPage) {
            SearchBar(searchVM: menuSearchVM)
                .padding()
        }
        .buttonStyle(.plain)
        .onChange(of: menuSearchVM.searchedTerm) { newValue in
            navigatior.currentPage = .search
            searchResultsVM.runSearch(newValue, authManager)
        }
    }
}

struct MenuSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MenuSearchView(menuSearchVM: MenuSearchViewModel())
    }
}
