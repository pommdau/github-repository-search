//
//  User.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import SwiftID

struct User: GitHubDTO, Equatable {
    
    // MARK: - Decode Result
    
    private enum CodingKeys: String, CodingKey {
        case rawID = "id"
        case login
        case name
        case avatarImagePath = "avatar_url"
        case htmlPath = "html_url"
        case location
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case followers
        case following
    }
    
    let rawID: Int
    var login: String
    var name: String
    var avatarImagePath: String
    var htmlPath: String?  // e.g. https://github.com/apple
    var location: String?
    var bio: String?
    var twitterUsername: String?
    var publicRepos: Int
    var followers: Int
    var following: Int
    
    // MARK: - Computed Property
    
    var id: SwiftID<Self> { "\(rawID)" }
    
    var avatarImageURL: URL? {
        //        guard let avatarImagePath else {
        //            return nil
        //        }
        return URL(string: avatarImagePath)
    }
    
    var htmlURL: URL? {
        guard let htmlPath else {
            return nil
        }
        return URL(string: htmlPath)
    }
    
    var twitterURL: URL? {
        guard let twitterUsername else {
            return nil
        }
        return URL(string: "https://x.com/\(twitterUsername)")
    }
}
