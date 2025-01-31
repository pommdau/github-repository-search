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
        case name = "login"
        case avatarImagePath = "avatar_url"
        case htmlPath = "html_url"
    }
    
    let rawID: Int
    var name: String
    var avatarImagePath: String
    var htmlPath: String  // e.g. https://github.com/apple
    
    // MARK: - Computed Property
    
    var id: SwiftID<Self> { "\(rawID)" }
    
    var avatarImageURL: URL? {
        URL(string: avatarImagePath)
    }
    
    var htmlURL: URL? {
        URL(string: htmlPath)
    }
}

extension User {
    static let sampleData: [User] = [
        User(rawID: 10639145,
             name: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
             avatarImagePath: "https://avatars.githubusercontent.com/u/10639145?v=4",
             htmlPath: "https://github.com/apple/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"),
        User(rawID: 12345678,
             name: "JohnDoe",
             avatarImagePath: "https://avatars.githubusercontent.com/u/12345678?v=4",
             htmlPath: "https://github.com/johndoe"),
        User(rawID: 23456789,
             name: "JaneSmith",
             avatarImagePath: "https://avatars.githubusercontent.com/u/23456789?v=4",
             htmlPath: "https://github.com/janesmith"),
        User(rawID: 34567890,
             name: "DevGuru",
             avatarImagePath: "https://avatars.githubusercontent.com/u/34567890?v=4",
             htmlPath: "https://github.com/devguru"),
        User(rawID: 45678901,
             name: "CodeMaster",
             avatarImagePath: "https://avatars.githubusercontent.com/u/45678901?v=4",
             htmlPath: "https://github.com/codemaster")
    ]
}

extension User {
    static func createRandom() -> User {
        let randomID = Int.random(in: 1000...9999)
        let randomName = ["alice", "bob", "charlie", "dave", "eve"].randomElement()!

        return User(
            rawID: randomID,
            name: randomName,
            avatarImagePath: "https://avatars.githubusercontent.com/\(randomName)",
            htmlPath: "https://github.com/\(randomName)"
        )
    }
}
