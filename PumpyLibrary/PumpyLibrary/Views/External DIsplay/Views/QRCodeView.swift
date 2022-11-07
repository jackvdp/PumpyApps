//
//  QRCodeView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 18/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct QRCodeView<P:PlaylistProtocol>: View {
    
    let width: CGFloat
    let height: CGFloat
    @EnvironmentObject var extDisMgr: ExternalDisplayManager<P>
    
    var body: some View {
        VStack {
            Divider()
                .padding([.leading, .bottom], height*0.05)
                .foregroundColor(.white)
            HStack {
//                Marquee {
                    Text(extDisMgr.getCorrectLabel())
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.custom(K.Font.helvetica, size: height * 0.03))
//                }
//                .marqueeDirection(.right2left)
//                .marqueeDuration(extDisMgr.qrTime())
//                .marqueeWhenNotFit(false)
                Spacer(minLength: height*0.02)
                if let image = extDisMgr.generateQRCode() {
                    Image(uiImage: image)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(height / 100)
                        .frame(width: height*0.1, height: height*0.1)
                }
            }
            .padding([.horizontal, .bottom], height*0.05)
        }
    }

    
}

#if DEBUG
struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QRCodeView<MockPlaylistManager>(width: 1080, height: 1920)
                .environmentObject(ExternalDisplayManager(username: "Test", playlistManager: MockPlaylistManager()))
                .previewLayout(.sizeThatFits)
                .frame(width: 1080, height: 1920)
            QRCodeView<MockPlaylistManager>(width: 1920, height: 1080)
                .environmentObject(ExternalDisplayManager(username: "Test", playlistManager: MockPlaylistManager()))
                .previewLayout(.sizeThatFits)
                .frame(width: 1920, height: 1080)
        }
    }
}
#endif
