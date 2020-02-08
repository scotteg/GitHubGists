//
//  GistsViewModel.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import Foundation

final class GistsViewModel {
    var gists = [Gist]()
    
    private var task: URLSessionTask?
    
    func fetchGists(for username: String, completion: @escaping () -> Void) {
        guard username.count > 2,
            let url = url(for: username)
            else {
                gists = []
                return completion()
        }
        
        getGists(for: url, completion: completion)
    }
    
    private func getGists(for url: URL, maxRetries: UInt = 2, completion: @escaping () -> Void) {
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if error != nil {
                if maxRetries > 0 {
                    self.getGists(for: url, maxRetries: maxRetries - 1, completion: completion)
                } else {
                    completion()
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let data = data {
                    do {
                        let gists = try JSONDecoder().decode([Gist].self, from: data)
                        self.gists = gists.sorted(by: >)
                        completion()
                    } catch {
                        self.gists = []
                        completion()
                    }
                } else {
                    self.gists = []
                    completion()
                }
            }
        }
        
        task?.resume()
    }
    
    private func url(for username: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users/\(username)/gists"
        return components.url
    }
}
