//
//  LoginUser.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

struct LoginUser: GitHubDTO {

    // MARK: - Decode Result
    
    enum CodingKeys: String, CodingKey {
        case rawID = "id"
        case login
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
            
    let rawID: Int
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
    
    // MARK: - Computed Property
    
    var id: SwiftID<Self> { "\(rawID)" }
        
    var twitterURL: URL? {
        guard let twitterUsername else {
            return nil
        }
        return URL(string: "https://x.com/\(twitterUsername)")
    }
}
