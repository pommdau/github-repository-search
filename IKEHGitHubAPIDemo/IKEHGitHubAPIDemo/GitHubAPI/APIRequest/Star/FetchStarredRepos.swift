//
//  GitHubAPIRequest+Star.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    
    struct FetchStarredRepos {
        
        // MARK: - Property
        
        var accessToken: String?
        
        var userName: String
        var page: Int?
        var perPage: Int?
        var sort: String? // "created" or "updated"
        var direction: String? // "desc" or "asc"
        
        var path: String
                
        // MARK: - LifeCycle
            
        init(
            userName: String,
            accessToken: String? = nil,
            perPage: Int = 5,
            sort: String? = nil,
            direction: String? = nil
        ) {
            self.accessToken = accessToken
            self.userName = userName
            self.page = nil
            self.perPage = perPage
            self.sort = sort
            self.direction = direction
            self.path = "/users/\(userName)/starred"
        }
                
        init(
            userName: String,
            link: RelationLink.Link,
            accessToken: String? = nil
        ) {
            self.accessToken = accessToken
            self.userName = userName
            if let page = link.queryItems["page"] {
                self.page = Int(page)
            }
            if let perPage = link.queryItems["per_page"] {
                self.perPage = Int(perPage)
            }
            if let sort = link.queryItems["sort"] {
                self.sort = sort
            }
            if let direction = link.queryItems["direction"] {
                self.direction = direction
            }
            self.path = link.url.path
        }
    }
}

extension GitHubAPIRequest.FetchStarredRepos: GitHubAPIRequestProtocol {

    typealias Response = StarredReposResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if let sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        
        if let direction {
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
        headerFields[.accept] = "application/vnd.github.star+json" // Includes a timestamp of when the star was created.
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
