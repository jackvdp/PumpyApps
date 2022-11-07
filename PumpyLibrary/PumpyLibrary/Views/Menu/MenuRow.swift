//
//  MenuRow.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct MenuRow: View {
    
    public init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
    
    let title: String
    let imageName: String
    
    public var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            Image(systemName: imageName)
                .foregroundColor(Color.white)
                .font(.system(size: 25, weight: .light))
                .frame(width: 30, height: 30)
            Text(title)
                .font(.headline)
        }
        .padding(.all, 10.0)
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(title: "Demo", imageName: "star")
    }
}
