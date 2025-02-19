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
    var login: String
    var avatarURL: String
    var url: String
    var htmlURL: String
    var name: String?
    var location: String?
    var email: String?
    var bio: String?
    var twitterUsername: String?
    var publicRepos: Int
    var publicGists: Int
    var followers: Int
    var following: Int
    var createdAt: String
    var updatedAt: String
    
    // MARK: - Computed Property
    
    var id: SwiftID<Self> { "\(rawID)" }
        
    var twitterURL: URL? {
        guard let twitterUsername else {
            return nil
        }
        return URL(string: "https://x.com/\(twitterUsername)")
    }
}
