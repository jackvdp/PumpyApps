//
//  MenuSearchViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/04/2022.
//

import Foundation
import PumpyAnalytics

class MenuSearchViewModel: SearchViewModel {

    @Published var searchTerm = String()
    @Published var searchedTerm = String()
    @Published var showSearchPage = false
    @Published var errorMessage = ErrorMessage("Error", "")
    @Published var showError = false
    
    let placeHolderText = "Search"
    
    func clearSearch() {
        searchTerm = String()
    }

    func runSearch() {
        searchedTerm = searchTerm
        showSearchPage = true
    }
}
