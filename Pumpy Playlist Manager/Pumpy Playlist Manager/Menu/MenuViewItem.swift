//
//  MenuViewItem.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 16/02/2022.
//

import SwiftUI

struct MenuItem<Content:View>: View {
    let destination: Content
    let label: String
    let image: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            Label(label, systemImage: image)
                .font(.title3)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 8)
    }
}

struct MenuViewItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(destination: EmptyView(), label: "Home", image: "house.fill")
        
    }
}
