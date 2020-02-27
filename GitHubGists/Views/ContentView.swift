//
//  ContentView.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/9/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = GistsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                
                List {
                    ForEach(viewModel.gists) { gist in
                        NavigationLink(destination: SafariView(url: gist.htmlURL)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)) {
                                GistView(gist: gist)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("GitHub Gists"))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIApplication.shared.windows
            .first { $0.isKeyWindow }?
            .endEditing(true)
    }
}
