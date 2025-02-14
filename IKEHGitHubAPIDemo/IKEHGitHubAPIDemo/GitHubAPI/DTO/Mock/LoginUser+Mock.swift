//
//  LoginUser+sampleData.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

extension LoginUser {
    enum Mock {
        static let ikeh: LoginUser = .init(
            rawID: 29433103,
            login: "pommdau",
            avatarURL: "https://avatars.githubusercontent.com/u/29433103?v=4",
            url: "https://api.github.com/users/pommdau",
            htmlURL: "https://github.com/pommdau",
            name: "IKEH",
            location: "Osaka",
            email: nil,
            bio: nil,
            twitterUsername: "ikeh1024",
            publicRepos: 104,
            publicGists: 5,
            followers: 20,
            following: 7,
            createdAt: "2017-06-14T13:32:48Z",
            updatedAt: "2024-12-21T12:20:29Z"
        )
    }
}
