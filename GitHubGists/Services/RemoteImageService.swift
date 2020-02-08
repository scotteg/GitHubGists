//
//  RemoteImageService.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import UIKit

final class RemoteImageService {
    static let shared = RemoteImageService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func getImage(at url: URL, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
            return nil
        } else {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                    let data = data,
                    let image = UIImage(data: data)
                    else { return }
                
                self.cache.setObject(self.resize(image: image), forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            task.resume()
            return task
        }
    }
    
    private func resize(image: UIImage, size: CGSize = CGSize(width: 64, height: 64)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
