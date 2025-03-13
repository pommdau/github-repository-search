//
//  RelationLinks.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftID

struct RelationLink: Sendable {
    
    struct Link: Identifiable, Equatable, Sendable {
        var id: SwiftID<Self>
        var url: URL
        var queryItems: [URLQueryItem]
    }
    
    var prev: Link?
    var next: Link?
    var last: Link?
    var first: Link?
}

extension RelationLink {
    /**
     レスポンスヘッダーのLink文字列からページング情報を作成します。
     
     - Parameter rawValue: HTTPレスポンスヘッダーのLink文字列。
     
     rawValueの例:
     ```
     <https://api.github.com/search/repositories?q=swift&page=2>; rel="next", <https://api.github.com/search/repositories?q=swift&page=34>; rel="last"
     <https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=2>; rel=\"next\", <https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=12>; rel=\"last\"
     ```
     */
    static func create(rawValue: String) -> RelationLink {
        var relationLink = RelationLink()
        let elements = rawValue.split(separator: ",")
        for element in elements {
            let linkElements = element.split(separator: ";")
            
            /*
             "<https://api.github.com/search/repositories?q=swift&page=2>"
             -> "https://api.github.com/search/repositories?q=swift&page=2"
             */
            let path = linkElements[0]
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
            
            guard let url = URL(string: path),
                  let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                continue
            }
        
            let queryItems = urlComponents.queryItems ?? []
            
            // rel="next" -> next
            let relationKey = linkElements[1]
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "rel=\"", with: "")
                .replacingOccurrences(of: "\"", with: "")
            
            switch relationKey {
            case "prev":
                relationLink.prev = .init(id: "\(relationKey)", url: url, queryItems: queryItems)
            case "next":
                relationLink.next = .init(id: "\(relationKey)", url: url, queryItems: queryItems)
            case "last":
                relationLink.last = .init(id: "\(relationKey)", url: url, queryItems: queryItems)
            case "first":
                relationLink.first = .init(id: "\(relationKey)", url: url, queryItems: queryItems)
            default:
                preconditionFailure()
            }
        }
        
        return relationLink
    }
}

// MARK: - Test用

import SwiftUI

#Preview {
    Button("Action") {
        RelationLink.test()
    }
}

extension RelationLink {
    static func test() {
/// <https://api.github.com/search/repositories?q=swift&page=2>; rel="next", <https://api.github.com/search/repositories?q=swift&page=34>; rel="last"
        let testString = """
     <https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=2>; rel=\"next\", <https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=12>; rel=\"last\"
"""
        let relationLink = RelationLink.create(rawValue: testString)
        print(relationLink)
        print("Completed")
    }
}
