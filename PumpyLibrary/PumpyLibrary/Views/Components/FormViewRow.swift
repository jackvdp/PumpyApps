//
//  FormViewRow.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 24/07/2022.
//

import Foundation
import SwiftUI

public struct FormViewRow: View {
    
    public init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
    
    let title: String
    let subTitle: String
    public var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(subTitle).foregroundColor(.gray)
        }
    }
}
