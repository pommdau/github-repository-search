//
//  HTTPFieldsTranslator.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/08.
//

import Foundation
import struct HTTPTypes.HTTPFields

struct HTTPFieldsTranslator {
    typealias DTO = HTTPFields
    typealias Entity = SearchResponseHeader

    static func translate(from httpFields: HTTPFields) -> SearchResponseHeader {
        var header: SearchResponseHeader = .init()
        
        if let link = httpFields.first(where: { $0.name.rawName == "Link" }) {
            header.ralationLink = RelationLink.create(rawValue: link.value)
        }
        
        return header
    }
}

