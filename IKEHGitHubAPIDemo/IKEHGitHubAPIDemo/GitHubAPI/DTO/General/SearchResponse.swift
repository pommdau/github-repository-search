//
//  SearchResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/07.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct SearchResponse<Item>: Sendable, Decodable, ResponseWithRelationLink where Item: Sendable & Decodable {

    // MARK: - レスポンスのBodyをDecodeして取得される情報
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }

    let totalCount: Int
    let items: [Item]
    
    // MARK: - レスポンスのHeaderから所得される情報
    
    var relationLink: RelationLink? // ページング情報
}
