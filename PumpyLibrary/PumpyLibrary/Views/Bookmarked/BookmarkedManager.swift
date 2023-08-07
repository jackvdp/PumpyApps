//
//  BookmarkedManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 03/08/2023.
//

import Foundation
import PumpyShared

public class BookmarkedManager: ObservableObject {
    
    public init() {}
    
    @Published private(set) var bookmarkedItems = [BookmarkedItem]() {
        didSet {
            saveBookmarks(bookmarkedItems)
        }
    }
    private var remoteListener: FirebaseListener?
    private var username: Username?
    private let debouncer = Debouncer()
    
    public func setUp(username: Username) {
        self.username = username
        listenForBookmarks()
    }
    
    deinit {
        print("deiniting Bookmark")
    }
    
    func listenForBookmarks() {
        if let username {
            remoteListener = FireMethods.listen(name: username,
                                                documentName: K.FStore.bookmarked,
                                                dataFieldName: K.FStore.bookmarked,
                                                decodeObject: [BookmarkedItem].self) { [weak self] blocked in
                self?.bookmarkedItems = blocked
            }
        }
    }
    
    func saveBookmarks(_ items: [BookmarkedItem]) {
        if let username {
            debouncer.handle {
                FireMethods.save(object: items,
                                 name: username,
                                 documentName: K.FStore.bookmarked,
                                 dataFieldName: K.FStore.bookmarked)
            }
        }
    }
    
    func toggleBookmarkedItem(_ item: BookmarkedItem) {
        if bookmarkedItems.contains(item) {
            bookmarkedItems.removeAll(where: { $0.id == item.id})
        } else {
            bookmarkedItems.append(item)
        }
    }
    
    func addTrackToBookmarks(_ item: BookmarkedItem) {
        if !bookmarkedItems.contains(item) {
            bookmarkedItems.append(item)
        }
    }
    
    func removeItem(_ item: BookmarkedItem) {
        bookmarkedItems.removeAll(where: { $0.id == item.id})
    }
    
    func removeListener() {
        remoteListener?.remove()
    }
    
}
