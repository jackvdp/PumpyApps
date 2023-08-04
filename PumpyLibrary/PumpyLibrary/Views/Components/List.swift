//
//  List.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 13/11/2022.
//

import SwiftUI

public struct PumpyListForEach<Data, ID, Content>: View where Data : RandomAccessCollection, ID : Hashable, Content: View {
    
    public init(_ data: Data,
                id: KeyPath<Data.Element, ID>,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }
    
    let data: Data
    let id: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Content
    
    public var body: some View {
        if data.isEmpty {
            Color.clear
        } else {
            List {
                ForEach(data, id: id) { element in
                    content(element)
                }
                .listRowBackground(Color.clear)
            }
            .background(Color.clear)
            .clearListBackgroundIOS16()
        }
    }
}

public struct PumpyList<Content: View>: View {
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    @ViewBuilder var content: Content
    
    public var body: some View {
        List() {
            content
                .listRowBackground(Color.clear)
        }
        .background(Color.clear)
        .clearListBackgroundIOS16()
    }
}

struct ClearListBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    public func clearListBackgroundIOS16() -> some View {
        modifier(ClearListBackground())
    }
}

// Extra

struct ListBackgroundColor: ViewModifier {

    let color: UIColor

    func body(content: Content) -> some View {
        content
            .onAppear() {
                UITableView.appearance().backgroundColor = self.color
                //(Optional) Edit colour of cell background
                UITableViewCell.appearance().backgroundColor = self.color
            }
    }
}

extension View {
    func listBackgroundColor(color: UIColor) -> some View {
        ModifiedContent(content: self, modifier: ListBackgroundColor(color: color))
    }

}
