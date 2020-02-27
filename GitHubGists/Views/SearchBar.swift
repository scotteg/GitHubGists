//
//  SearchBar.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/9/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    final class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.placeholder = "Enter GitHub username"
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}
