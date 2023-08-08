//
//  RecentlyPlayedManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 07/08/2023.
//

import Foundation
import PumpyAnalytics

public class RecentlyPlayedManager: ObservableObject {
    
    public init() {}
    
    @Published private(set) var items = BoundedArray<BookmarkedItem>(maxSize: 10)
    
    func addItem(_ item: BookmarkedItem) {
        if items.contains(where: { $0.id == item.id}) {
            items.removeAll(where: { $0.id == item.id })
        }
        items.prepend(item)
    }
    
}

struct BoundedArray<T:Codable>: RandomAccessCollection {
    func index(after i: Int) -> Int {
        array.index(after: i)
    }
    
    var startIndex: Int { array.startIndex }
    var endIndex: Int { array.endIndex }
    
    @UserDefaultsStorage(
        key: K.recentlyPlayedKey,
        defaultValue: [T]()
    ) private var array: [T]
    private let maxSize: Int

    init(maxSize: Int) {
        self.maxSize = maxSize
    }

    var count: Int {
        return array.count
    }

    mutating func prepend(_ element: T) {
        array.insert(element, at: 0)
        while array.count > maxSize {
            array.removeLast()
        }
    }

    subscript(index: Int) -> T {
        return array[index]
    }
    
    mutating func removeAll(where method: (T) -> (Bool)) {
        array.removeAll(where: method)
    }
}
