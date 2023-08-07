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
        self.items.prepend(item)
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
        array.append(element)
        while array.count > maxSize {
            array.removeLast()
        }
    }

    subscript(index: Int) -> T {
        return array[index]
    }
}
