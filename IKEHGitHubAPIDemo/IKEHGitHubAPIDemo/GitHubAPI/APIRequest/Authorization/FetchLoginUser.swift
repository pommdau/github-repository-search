//
//  FetchLoginUser.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//
//  refs: https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchLoginUser {
        var accessToken: String
    }
}

extension GitHubAPIRequest.FetchLoginUser: GitHubAPIRequestProtocol {

    typealias Response = LoginUser
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/user"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.authorization] = "Bearer \(accessToken)"
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}

/*
 {
   "login": "octocat",
   "id": 1,
   "node_id": "MDQ6VXNlcjE=",
   "avatar_url": "https://github.com/images/error/octocat_happy.gif",
   "gravatar_id": "",
   "url": "https://api.github.com/users/octocat",
   "html_url": "https://github.com/octocat",
   "followers_url": "https://api.github.com/users/octocat/followers",
   "following_url": "https://api.github.com/users/octocat/following{/other_user}",
   "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
   "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
   "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
   "organizations_url": "https://api.github.com/users/octocat/orgs",
   "repos_url": "https://api.github.com/users/octocat/repos",
   "events_url": "https://api.github.com/users/octocat/events{/privacy}",
   "received_events_url": "https://api.github.com/users/octocat/received_events",
   "type": "User",
   "site_admin": false,
   "name": "monalisa octocat",
   "company": "GitHub",
   "blog": "https://github.com/blog",
   "location": "San Francisco",
   "email": "octocat@github.com",
   "hireable": false,
   "bio": "There once was...",
   "twitter_username": "monatheoctocat",
   "public_repos": 2,
   "public_gists": 1,
   "followers": 20,
   "following": 0,
   "created_at": "2008-01-14T04:33:35Z",
   "updated_at": "2008-01-14T04:33:35Z",
   "private_gists": 81,
   "total_private_repos": 100,
   "owned_private_repos": 100,
   "disk_usage": 10000,
   "collaborators": 8,
   "two_factor_authentication": true,
   "plan": {
     "name": "Medium",
     "space": 400,
     "private_repos": 20,
     "collaborators": 0
   }
 }
 */
