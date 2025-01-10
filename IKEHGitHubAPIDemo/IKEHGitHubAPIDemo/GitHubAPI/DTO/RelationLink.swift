//
//  RelationLinks.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftID

struct RelationLink: Equatable, Sendable {
    
    struct Link: Identifiable, Equatable, Sendable {
        struct ID: StringIDProtocol {
            let rawValue:  String
            init(rawValue: String) {
                self.rawValue = rawValue
            }
        }
        var id: ID
        var url: URL
        var word: String
        var page: Int
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
     Link: <https://api.github.com/search/repositories?q=swift&page=2>; rel="next", <https://api.github.com/search/repositories?q=swift&page=34>; rel="last"
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
                  let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let queryItems = urlComponents.queryItems,
                  let wordItem = queryItems.first(where: { $0.name == "q" }),
                  let word = wordItem.value,
                  let pageItem = queryItems.first(where: { $0.name == "page" }),
                  let pageValue = pageItem.value,
                  let pageNumber = Int(pageValue) else {
                continue
            }
            
            // rel="next" -> next
            let relationKey = linkElements[1]
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "rel=\"", with: "")
                .replacingOccurrences(of: "\"", with: "")
            
            switch relationKey {
            case "prev":
                relationLink.prev = .init(id: "\(relationKey)", url: url, word: word, page: pageNumber)
            case "next":
                relationLink.next = .init(id: "\(relationKey)", url: url, word: word, page: pageNumber)
            case "last":
                relationLink.last = .init(id: "\(relationKey)", url: url, word: word, page: pageNumber)
            case "first":
                relationLink.first = .init(id: "\(relationKey)", url: url, word: word, page: pageNumber)
            default:
                preconditionFailure()
            }
        }
        
        return relationLink
    }
}

// MARK: - Test用

extension RelationLink {
    static func test() {
        let testString = """
 <https://api.github.com/search/repositories?q=swift&page=2>; rel="next", <https://api.github.com/search/repositories?q=swift&page=34>; rel="last"
"""
        let relationLink = RelationLink.create(rawValue: testString)
        print(relationLink)
        print("Check")
    }
}
