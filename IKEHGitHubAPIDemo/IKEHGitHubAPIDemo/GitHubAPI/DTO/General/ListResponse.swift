//
//  StarredReposResponse.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/26.
//

import Foundation

protocol ResponseWithRelationLink {
    var relationLink: RelationLink? { get set } // ページング情報
}

struct ListResponse<Item: Decodable & Sendable>: Sendable, ResponseWithRelationLink {
    var items: [Item]
    
    // MARK: - レスポンスのHeaderから所得される情報
    var relationLink: RelationLink? // ページング情報
}

extension ListResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.items = try container.decode([Item].self)
    }
}
