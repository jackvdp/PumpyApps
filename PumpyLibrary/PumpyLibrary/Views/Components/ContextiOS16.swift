//
//  ContextiOS16.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 06/11/2022.
//

import Foundation
import SwiftUI

struct ContextiOS16<V: View, P: View>: ViewModifier {
    
    let menuItem: () -> V
    let preview: () -> P
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .contextMenu {
                    menuItem()
                } preview: {
                    preview()
                }

        } else {
            content
                .contextMenu {
                    menuItem()
                    preview()
                }
        }
    }
}

extension View {
    func contextWithPreview<V: View, P: View>(menuItem: @escaping ()->V, preview: @escaping ()->P) -> some View {
        modifier(ContextiOS16(menuItem: menuItem, preview: preview))
    }
}
