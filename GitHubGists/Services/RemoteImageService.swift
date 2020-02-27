//
//  RemoteImageService.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import SwiftUI
import Combine

final class RemoteImageService {
    static let shared = RemoteImageService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
        
    func avatarPublisher(for url: URL) -> AnyPublisher<UIImage, Never> {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            return Just(image).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(2)
            .map(\.data)
            .compactMap(UIImage.init)
            .compactMap { [weak self] in
                self?.resize(image: $0)
            }
            .replaceError(with: UIImage(systemName: "person.circle.fill")!)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func resize(image: UIImage, size: CGSize = CGSize(width: 64, height: 64)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
