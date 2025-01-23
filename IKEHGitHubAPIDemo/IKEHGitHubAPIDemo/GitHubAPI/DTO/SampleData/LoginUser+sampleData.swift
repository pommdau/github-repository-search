//
//  LoginUser+sampleData.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

extension LoginUser {
    
    static func sampleData() -> LoginUser {
        guard let data = jsonString.data(using: .utf8) else {
            fatalError()
        }
        do {
            return try JSONDecoder().decode(LoginUser.self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension LoginUser {
    static let jsonString = """
    {
      "login": "pommdau",
      "id": 29433103,
      "node_id": "MDQ6VXNlcjI5NDMzMTAz",
      "avatar_url": "https://avatars.githubusercontent.com/u/29433103?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/pommdau",
      "html_url": "https://github.com/pommdau",
      "followers_url": "https://api.github.com/users/pommdau/followers",
      "following_url": "https://api.github.com/users/pommdau/following{/other_user}",
      "gists_url": "https://api.github.com/users/pommdau/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/pommdau/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/pommdau/subscriptions",
      "organizations_url": "https://api.github.com/users/pommdau/orgs",
      "repos_url": "https://api.github.com/users/pommdau/repos",
      "events_url": "https://api.github.com/users/pommdau/events{/privacy}",
      "received_events_url": "https://api.github.com/users/pommdau/received_events",
      "type": "User",
      "user_view_type": "public",
      "site_admin": false,
      "name": "IKEH",
      "company": null,
      "blog": "",
      "location": "Osaka",
      "email": null,
      "hireable": null,
      "bio": null,
      "twitter_username": "ikeh1024",
      "notification_email": null,
      "public_repos": 104,
      "public_gists": 5,
      "followers": 20,
      "following": 7,
      "created_at": "2017-06-14T13:32:48Z",
      "updated_at": "2024-12-21T12:20:29Z"
    }
    """
}
