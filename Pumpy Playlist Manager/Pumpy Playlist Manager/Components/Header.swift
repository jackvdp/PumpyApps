//
//  Header.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 16/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct Header<T: NavigationManager>: View {
    
    @ObservedObject var navManager: T
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let backPage = navManager.currentPage.previousPage() {
                    Button {
                        navManager.currentPage = backPage
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.pumpyPink)
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing)
                }
                Text(navManager.currentPage.headerTitle())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }
            Divider()
        }
        .padding([.top, .horizontal])
    }
}

//struct Header_Previews: PreviewProvider {
//    static var previews: some View {
//        Header()
//            .environmentObject(NavigationManager())
//    }
//}
