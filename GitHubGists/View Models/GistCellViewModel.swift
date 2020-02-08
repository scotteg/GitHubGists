//
//  GistCellViewModel.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import UIKit

final class GistCellViewModel {
    let gist: Gist
    lazy var gistDescription = gist.gistDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    lazy var lastUpdatedString = "Last updated " + gist.updatedAt
    lazy var urlString = gist.htmlURL.absoluteString
    var task: URLSessionTask?
    
    init(gist: Gist) {
        self.gist = gist
    }
    
    func fetchAvatar(completion: @escaping (UIImage) -> Void) {
        task = RemoteImageService.shared.getImage(at: gist.owner.avatarURL, completion: completion)
    }
    
    func cancelFetchAvatar() {
        task?.cancel()
    }
}
