//
//  GistsViewModel.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import Foundation
import Combine

final class GistsViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var gists: [Gist] = []
    
    private let maxRetries: Int
    private var subscriptions = Set<AnyCancellable>()
    
    init(maxRetries: UInt = 2) {
        self.maxRetries = Int(maxRetries)
        
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .flatMap(fetchGists(for:))
            .map { $0.sorted(by: >) }
            .assign(to: \.gists, on: self)
            .store(in: &subscriptions)
    }
    
    private func fetchGists(for username: String) -> AnyPublisher<[Gist], Never> {
        Just(username)
            .handleEvents(receiveOutput: { [weak self] in
                if $0.count < 3 {
                    self?.gists = []
                }
            })
            .filter { $0.count > 2 }
            .tryMap(url(for:))
            .flatMap(gistsPublisher(for:))
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func gistsPublisher(for url: URL) -> AnyPublisher<[Gist], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .retry(maxRetries)
            .map(\.data)
            .decode(type: [Gist].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func url(for username: String) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users/\(username)/gists"
        guard let url = components.url else { throw URLError(.badURL) }
        return url
    }
}
