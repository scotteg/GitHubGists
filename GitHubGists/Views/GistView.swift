//
//  GistView.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/9/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import SwiftUI

struct GistView: View {
    @ObservedObject private var viewModel: GistCellViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                VStack {
                    viewModel.avatarImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .clipShape(Circle())
                    
                    Text(viewModel.gist.owner.login)
                        .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                }
                
                Text(viewModel.gist.gistDescription)
                    .font(.headline)
                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            }
            
            Text("Last updated " + viewModel.gist.updatedAt)
                .font(.caption)
                .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
            
            Text(viewModel.gist.htmlURL.absoluteString)
                .font(.caption)
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)))
        }
    }
    
    init(gist: Gist) {
        viewModel = GistCellViewModel(gist: gist)
    }
}
