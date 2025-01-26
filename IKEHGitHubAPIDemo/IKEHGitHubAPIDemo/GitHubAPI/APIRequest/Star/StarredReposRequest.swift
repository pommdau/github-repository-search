//
//  GitHubAPIRequest+Star.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct StarredReposRequest {
        // TODO: Protocolに切り出しても良いかも
        var userName: String
        var accessToken: String?
        var query: String
        var page: Int?
        var perPage: Int? = 10
        var sortedBy: SortBy = .recentryStarred
    }
}

// MARK: - 検索タイプ

extension GitHubAPIRequest.StarredReposRequest {
    enum SortBy: String, CaseIterable, Identifiable, Equatable {
        case recentryStarred // クエリで指定しない場合のデフォルト
        case recentryActive
        case leastRecentlyStarred
        case leastRecentlyActive
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .recentryStarred:
                return "Recently starred"
            case .recentryActive:
                return "Recentrly active"
            case .leastRecentlyStarred:
                return "Least recently starred"
            case .leastRecentlyActive:
                return "Least recentrly active"
            }
        }
        
        // MARK: - Query Parameter
        
        var sort: String? {
            switch self {
            case .recentryStarred, .leastRecentlyStarred: // リポジトリへのスター日時
                return "created"
            case .recentryActive, .leastRecentlyActive: // リポジトリへの最終Push日時
                return "updated"
                
            }
        }
        
        var direction: String? {
            switch self {
            case .recentryStarred, .recentryActive:
                return "desc"
            case .leastRecentlyStarred, .leastRecentlyActive:
                return "asc"
            }
        }
    }
}

extension GitHubAPIRequest.StarredReposRequest : GitHubAPIRequestProtocol {

    typealias Response = [Repo]
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/users/\(userName)/starred"
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: query))
        
        if let sort = sortedBy.sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        
        if let direction = sortedBy.direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction))
        }
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let perPage {
            queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        }
        
        return queryItems
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = HTTPField.ConstantValue.applicationVndGitHubJSON
        if let accessToken {
            headerFields[.authorization] = "Bearer \(accessToken)"
        }
        headerFields[.xGithubAPIVersion] = HTTPField.ConstantValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
