//
//  HomeVM.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI

public protocol HomeProtocol: ObservableObject {
    
    var pageType: PageType { get set }
    var showMenu: Bool { get set }
    
    func playPause()
    func coldStart()
    func skipToNextItem()
}

public enum PageType {
    case artwork
    case upNext
}

class MockHomeVM: HomeProtocol {
    @Published var pageType: PageType = .artwork
    @Published var showMenu = false
    
    func playPause() { }
    func coldStart() { }
    func skipToNextItem() {}
}
