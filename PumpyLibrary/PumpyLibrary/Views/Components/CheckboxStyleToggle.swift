//
//  CheckboxStyleToggle.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/03/2023.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Color.white
                .frame(width: 18, height: 18)
                .opacity(configuration.isOn ? 1 : 0)
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .pumpyPink : .gray)
                .font(.system(size: 16, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
