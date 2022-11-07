//
//  StatusView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/05/2022.
//

import Foundation
import SwiftUI

struct StatusView: View {
    
    var label: String
    var recieved: Int
    var failed: Int
    var inProgress: Int
    var total: Int
    
    var body: some View {
        HStack(spacing: 10) {
            progressCircle
            labels
        }
    }
    
    var progressCircle: some View {
        ProgressView(
            value: Float(recieved),
            total: Float(total)
        )
            .progressViewStyle(.circular)
    }
    
    var labels: some View {
        VStack(alignment: .leading) {
            Text("**\(label)**: \(recieved)")
            Text("Failed: \(failed)")
            if inProgress != 0 {
                Text("In progress: \(inProgress)")
            } else {
                Text("\(Image(systemName: "checkmark"))")
                    .foregroundColor(.pumpyPink)
            }
        }
        .font(.caption)
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(label: "Analysed",
                   recieved: 100,
                   failed: 3,
                   inProgress: 0,
                   total: 203)
    }
}
