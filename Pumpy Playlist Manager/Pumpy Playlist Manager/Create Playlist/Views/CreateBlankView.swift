//
//  CreateBlankView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI

struct CreateBlankView: View {
    
    let number: Int
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "\(number).circle")
                .resizable()
                .foregroundColor(Color.white)
                .opacity(0.5)
                .padding(width * 0.25)
                .aspectRatio(1, contentMode: .fit)
                .frame(height: (width - 32) * 2)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .clipped()
        }
        .padding()
        .frame(maxWidth: 250)
    }
}

struct CreateBlankView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBlankView(number: 2, width: 200)
            .frame(width: 500, height: 200, alignment: .center)
    }
}
