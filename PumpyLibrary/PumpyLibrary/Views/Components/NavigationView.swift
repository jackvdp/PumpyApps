//
//  NavigationView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 29/07/2023.
//

import SwiftUI

/// If you want to use this, you need to go the full way and use a seperate coordinator for navigation.
/// Don't use NavigationLink/NavigationTitle/TitleDispalyMode
/// Instead use navigator coordiantor class to set all this
struct PumpyNavigationView<Content: View>: View {
    
    var initialTitle: String?
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        NavRepresentable(initialTitle: initialTitle) {
            content()
        }
    }
    
    private struct NavRepresentable: UIViewControllerRepresentable {
        var initialTitle: String?
        let content: () -> Content
        
        func makeUIViewController(context: Context) -> UINavigationController {
            let navController = UINavigationController()
            navController.delegate = context.coordinator
            navController.navigationBar.prefersLargeTitles = false
            let hostingController = UIHostingController(rootView: content())
            navController.pushViewController(hostingController, animated: false)
            navController.viewControllers.forEach { vc in
                vc.view.backgroundColor = .clear
            }
            return navController
        }
        
        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator()
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate {
            
            func navigationController(_ navigationController: UINavigationController,
                                      willShow viewController: UIViewController,
                                      animated: Bool) {
                viewController.view.backgroundColor = .clear
            }
        }
    }
    
}
