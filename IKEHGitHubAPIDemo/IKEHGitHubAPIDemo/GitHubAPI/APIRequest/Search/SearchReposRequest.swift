//
//  NewSearchRequest.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct SearchReposRequest {
        // TODO: Protocolに切り出しても良いかも
        var accessToken: String?
        var query: String
        var page: Int?
        var perPage: Int? = 3
        var sortedBy: SortBy = .bestMatch
    }
}

// MARK: - 検索タイプ

extension GitHubAPIRequest.SearchReposRequest {
    // Webの検索を参考に
    // https://github.com/search?q=Swift&type=repositories
    enum SortBy: String, CaseIterable, Identifiable, Equatable {
        case bestMatch
        case mostStars
        case fewestStars
        case mostForks
        case fewestForks
        case recentryUpdated
        case leastRecentlyUpdated
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .bestMatch:
                return "Best match"
            case .mostStars:
                return "Most stars"
            case .fewestStars:
                return "Fewest stars"
            case .mostForks:
                return "Most forks"
            case .fewestForks:
                return "Fewest forks"
            case .recentryUpdated:
                return "Recently updated"
            case .leastRecentlyUpdated:
                return "Least recently updated"
            }
        }
        
        // MARK: - Query Parameter
        
        var sort: String? {
            switch self {
            case .bestMatch:
                return nil
            case .mostStars, .fewestStars:
                return "stars"
            case .mostForks, .fewestForks:
                return "forks"
            case .recentryUpdated, .leastRecentlyUpdated:
                return "updated"
            }
        }
        
        var order: String? {
            switch self {
            case .bestMatch:
                return nil
            case .mostStars, .mostForks, .recentryUpdated:
                return "desc"
            case .fewestStars, .fewestForks, .leastRecentlyUpdated:
                return "asc"
            }
        }
    }
}

extension GitHubAPIRequest.SearchReposRequest : GitHubAPIRequestProtocol {

    typealias Response = SearchResponse<Repo>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com/search")
    }
    
    var path: String {
        "/repositories"
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: query))
        
        if let sort = sortedBy.sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        
        if let order = sortedBy.order {
            queryItems.append(URLQueryItem(name: "order", value: order))
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
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        if let accessToken {
            headerFields[.authorization] = "Bearer \(accessToken)"
        }
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
