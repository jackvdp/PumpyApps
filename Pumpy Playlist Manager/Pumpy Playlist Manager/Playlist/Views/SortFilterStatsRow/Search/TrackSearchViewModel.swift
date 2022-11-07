//
//  TrackSearchViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/02/2022.
//

import Foundation
import SwiftUI
import PumpyAnalytics

class TrackSearchViewModel: SearchViewModel {
    
    @Published var searchTerm = String()
    @Published var errorMessage: ErrorMessage = ErrorMessage("Error", "")
    @Published var showError = false
    
    let placeHolderText: String = "Search tracks..."
    
    func clearSearch() {
        searchTerm = String()
    }
    
    func runSearch() {}
    
}
