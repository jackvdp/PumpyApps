//
//  NavigationModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 03/03/2022.
//

import Foundation

protocol NavigationManager: ObservableObject {
    associatedtype T: NavigationSection
    var currentPage: T { get set }
}

protocol NavigationSection {
    func defaultPage() -> Self
    func headerTitle() -> String
    func previousPage() -> Self?
}
