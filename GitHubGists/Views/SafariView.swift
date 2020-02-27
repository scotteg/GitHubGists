//
//  SafariView.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/9/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let url: URL
    
    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        @Binding var presentationMode: PresentationMode
        
        init(presentationMode: Binding<PresentationMode>) {
            _presentationMode = presentationMode
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            presentationMode.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode)
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.preferredBarTintColor = .white
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiView: SFSafariViewController, context: Context) {

    }
}
