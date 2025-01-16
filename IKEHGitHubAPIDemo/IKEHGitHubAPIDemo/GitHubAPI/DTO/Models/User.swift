//
//  User.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct User: Identifiable, Equatable, Sendable & Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarImagePath = "avatar_url"
        case htmlPath = "html_url"
    }
    
    let id: Int
    let name: String
    let avatarImagePath: String
    let htmlPath: String  // e.g. https://github.com/apple
    
    var htmlURL: URL? {
        URL(string: htmlPath)
    }
}

extension User {
    static let sampleData: [User] = [
        User(id: 10639145,
             name: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
             avatarImagePath: "https://avatars.githubusercontent.com/u/10639145?v=4",
             htmlPath: "https://github.com/apple/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"),
        User(id: 12345678,
             name: "JohnDoe",
             avatarImagePath: "https://avatars.githubusercontent.com/u/12345678?v=4",
             htmlPath: "https://github.com/johndoe"),
        User(id: 23456789,
             name: "JaneSmith",
             avatarImagePath: "https://avatars.githubusercontent.com/u/23456789?v=4",
             htmlPath: "https://github.com/janesmith"),
        User(id: 34567890,
             name: "DevGuru",
             avatarImagePath: "https://avatars.githubusercontent.com/u/34567890?v=4",
             htmlPath: "https://github.com/devguru"),
        User(id: 45678901,
             name: "CodeMaster",
             avatarImagePath: "https://avatars.githubusercontent.com/u/45678901?v=4",
             htmlPath: "https://github.com/codemaster")
    ]
}
