//
//  SearchViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import Foundation
import PumpyAnalytics

protocol SearchViewModel: ObservableObject {
    var searchTerm: String { get set }
    var errorMessage: ErrorMessage { get set}
    var showError: Bool { get set}
    var placeHolderText: String { get }
    
    func clearSearch()
    
    func runSearch()
}
