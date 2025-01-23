//
//  LoginUser.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

struct LoginUser: Codable, Identifiable, Sendable {
    let id: Int
    let login: String
    let avatarURL: String
    let url: String
    let htmlURL: String
    let name: String?
    let location: String?
    let email: String?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
        case name
        case location
        case email
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // MARK: - Computed Property
    
    var twitterURL: URL? {
        guard let twitterUsername else {
            return nil
        }
        return URL(string: "https://x.com/\(twitterUsername)")
    }
}
