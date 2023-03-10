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
                .frame(width: 22, height: 22)
                .opacity(configuration.isOn ? 1 : 0)
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .pumpyPink : .gray)
                .font(.system(size: 20, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
