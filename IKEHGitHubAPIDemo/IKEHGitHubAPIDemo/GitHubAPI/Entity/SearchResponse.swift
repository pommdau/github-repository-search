//
//  SearchResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/07.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct SearchResponse<Item: Decodable>: Decodable {

    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }

    let totalCount: Int
    let items: [Item]
}
