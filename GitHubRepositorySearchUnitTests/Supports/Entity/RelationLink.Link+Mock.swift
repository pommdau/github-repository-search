//
//  RelationLink.Link+Mock.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/06/09.
//

import Foundation
import XCTest
import IKEHGitHubAPIClient
@testable import GitHubRepositorySearch

extension RelationLink.Link {
    enum Mock {
        /// リポジトリ検索のNextリンクを生成するUtils
        static func createSearchReposNext(query: String, perPage: Int, page: Int) throws -> RelationLink.Link {
            .init(
                id: "next",
                url: try XCTUnwrap(URL(string: "https://api.github.com/search/repositories?q=\(query)&per_page=\(perPage)&page=\(page)")),
                queryItems: [
                    .init(name: "q", value: query),
                    .init(name: "per_page", value: "\(perPage)"),
                    .init(name: "page", value: "\(page)")
                ]
            )
        }
        
        /// ユーザのリポジトリ一覧取得のNextリンクを生成するUtils
        static func createFetchAuthenticatedUserReposNext(
            sort: String = "updated",
            direction: String = "desc",
            perPage: Int,
            page: Int
        ) throws -> RelationLink.Link {
            .init(
                id: "next",
                url: try XCTUnwrap(URL(string: "https://api.github.com/user/repos?sort=\(sort)&direction=\(direction)&per_page=\(perPage)&page=\(page)")),
                queryItems: [
                    .init(name: "sort", value: sort),
                    .init(name: "direction", value: direction),
                    .init(name: "per_page", value: "\(perPage)"),
                    .init(name: "page", value: "\(page)")
                ]
            )
        }
    }
}
