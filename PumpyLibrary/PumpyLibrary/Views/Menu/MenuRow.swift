//
//  MenuRow.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct MenuRow: View {
    
    public init(title: String, imageName: String, showChevron: Bool = false) {
        self.title = title
        self.imageName = imageName
        self.showChevron = showChevron
    }
    
    let title: String
    let imageName: String
    let showChevron: Bool
    
    public var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            Image(systemName: imageName)
                .foregroundColor(Color.white)
                .font(.system(size: 25, weight: .light))
                .frame(width: 30, height: 30)
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            if showChevron {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.all, 10.0)
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(title: "Demo", imageName: "star")
    }
}
