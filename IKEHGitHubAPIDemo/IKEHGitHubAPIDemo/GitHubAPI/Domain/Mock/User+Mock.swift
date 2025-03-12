//
//  User+Mock.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/08.
//

import Foundation

extension User {
    enum Mock {
        
        static func random(count: Int) -> [User] {
            (0..<count).map { _ in random() }
        }
        
        static func random() -> User {
            let randomID = Int.random(in: 1000...9999)
            let randomLogin = ["alice", "bob", "charlie", "dave", "eve"].randomElement() ?? ""
//            let randomName = ["Alice Johnson", "Bob Smith", "Charlie Brown", "Dave Williams", "Eve Adams"].randomElement() ?? ""
//            let randomLocation = ["New York", "San Francisco", "Tokyo", "Berlin", "London"].randomElement() ?? ""
//            let randomBio = ["iOS Developer", "Swift Enthusiast", "Open Source Contributor", "Tech Blogger", "GitHub Fan"].randomElement() ?? ""
//            let randomTwitter = ["alice_dev", "bob_swift", "charlie_code", "dave_ios", "eve_git"].randomElement()
//            let randomRepos = Int.random(in: 1...100)
//            let randomFollowers = Int.random(in: 0...5000)
//            let randomFollowing = Int.random(in: 0...500)
            
            return User(
                rawID: randomID,
                login: randomLogin,
//                name: randomName,
                avatarImagePath: "https://avatars.githubusercontent.com/u/29433103?v=4",
                htmlPath: "https://github.com/pommdau"
//                location: randomLocation,
//                bio: randomBio,
//                twitterUsername: randomTwitter,
//                publicRepos: randomRepos,
//                followers: randomFollowers,
//                following: randomFollowing
            )
        }
    }
}

/*
 {
   "login":"pommdau",
   "id":29433103,
   "node_id":"MDQ6VXNlcjI5NDMzMTAz",
   "avatar_url":"https://avatars.githubusercontent.com/u/29433103?v=4",
   "gravatar_id":"",
   "url":"https://api.github.com/users/pommdau",
   "html_url":"https://github.com/pommdau",
   "followers_url":"https://api.github.com/users/pommdau/followers",
   "following_url":"https://api.github.com/users/pommdau/following{/other_user}",
   "gists_url":"https://api.github.com/users/pommdau/gists{/gist_id}",
   "starred_url":"https://api.github.com/users/pommdau/starred{/owner}{/repo}",
   "subscriptions_url":"https://api.github.com/users/pommdau/subscriptions",
   "organizations_url":"https://api.github.com/users/pommdau/orgs",
   "repos_url":"https://api.github.com/users/pommdau/repos",
   "events_url":"https://api.github.com/users/pommdau/events{/privacy}",
   "received_events_url":"https://api.github.com/users/pommdau/received_events",
   "type":"User",
   "user_view_type":"public",
   "site_admin":false,
   "name":"IKEH",
   "company":null,
   "blog":"",
   "location":"Osaka",
   "email":null,
   "hireable":null,
   "bio":null,
   "twitter_username":"ikeh1024",
   "public_repos":104,
   "public_gists":6,
   "followers":22,
   "following":7,
   "created_at":"2017-06-14T13:32:48Z",
   "updated_at":"2024-12-21T12:20:29Z"
 }
 */
