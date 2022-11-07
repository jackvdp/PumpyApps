//
//  PlayerShowButton.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/04/2022.
//

import SwiftUI

struct PlayerShowButton: View {
    
    @Binding var showing: Bool
    
    var body: some View {
        Button {
            withAnimation {
                showing.toggle()
            }
        } label: {
            ZStack {
//                Image(systemName: "rectangle.roundedtop")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 33, height: 22)
//                Image(systemName: "rectangle.roundedtop.fill")
//                    .resizable()
//                    .foregroundColor(Color(NSColor.windowBackgroundColor))
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 30, height: 20)
                Image(systemName: showing ? "chevron.down" : "chevron.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
                    .font(Font.title.weight(.bold))
            }
            .padding(.horizontal)
            .frame(height: 17, alignment: .top)
        }
        .buttonStyle(.plain)
    }
}

struct PlayerShowButton_Previews: PreviewProvider {

    static var previews: some View {
        PlayerShowButton(showing: .constant(false))
    }
}
