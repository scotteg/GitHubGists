//
//  Gist.swift
//  GitHubGists
//
//  Created by Scott Gardner on 2/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import Foundation

struct Gist: Identifiable {
    static let iso8601DateFormatter = ISO8601DateFormatter()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    let id = UUID()
    let htmlURL: URL
    let updatedAtDate: Date
    let updatedAt: String
    let gistDescription: String
    let owner: Owner
}

extension Gist: Hashable {
    static func == (lhs: Gist, rhs: Gist) -> Bool {
        lhs.htmlURL == rhs.htmlURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(htmlURL)
    }
}

extension Gist: Comparable {
    static func <(lhs: Gist, rhs: Gist) -> Bool {
        lhs.updatedAtDate < rhs.updatedAtDate
    }
}

extension Gist: Decodable {
    enum CodingKeys: String, CodingKey {
        case htmlURL = "html_url"
        case updatedAt = "updated_at"
        case gistDescription = "description"
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let htmlURLString = try container.decode(String.self, forKey: .htmlURL)
        htmlURL = URL(string: htmlURLString)!
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        updatedAtDate = Self.iso8601DateFormatter.date(from: updatedAtString)!
        updatedAt = Self.dateFormatter.string(from: updatedAtDate)
        gistDescription = try container.decodeIfPresent(String.self, forKey: .gistDescription) ?? "No description"
        owner = try container.decode(Owner.self, forKey: .owner)
    }
}
