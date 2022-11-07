//
//  LoggedInView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import SwiftUI

struct LoggedInView: View {
    
    let username: String
    let signOutFunction: () -> ()
    
    var body: some View {
        HStack {
            Text(username)
            Spacer()
            Button("Sign Out", action: signOutFunction)
        }
        .padding()
        .background(
            Rectangle()
                .foregroundColor(Color(NSColor.controlBackgroundColor))
                .cornerRadius(10)
        )
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView(username: "jackvanderpump@me.com", signOutFunction: {})
    }
}
