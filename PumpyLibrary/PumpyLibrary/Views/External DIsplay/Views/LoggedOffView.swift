//
//  LoggedOffView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct ExtLoggedOffView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                VStack {
                    PumpyView()
                        .padding()
                        .frame(width: geo.size.width * 0.5)
                }
            }
        }
    }
}

#if DEBUG
struct LoggedOffView_Previews: PreviewProvider {
    static var previews: some View {
        ExtLoggedOffView()
            .previewLayout(.sizeThatFits)
            .frame(width: 1920, height: 1080)
    }
}
#endif
