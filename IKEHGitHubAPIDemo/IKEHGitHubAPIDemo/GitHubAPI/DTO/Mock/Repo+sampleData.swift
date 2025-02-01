//
//  Repo+sampleData.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/13.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension Repo {
    
    struct Mock {
        
        static func createRandom(count: Int) -> [Repo] {
            (0..<count).map { _ in createRandom() }
        }
        
        static func createRandom() -> Repo {
            let randomID = Int.random(in: 1000...9999)
            let randomName = ["Tetris", "Chess", "Snake", "Pong", "Breakout"].randomElement()!
            let randomOwner = User.createRandom()
            let randomLanguage = ["Swift", "Python", "JavaScript", "C++", "Rust"].randomElement()
            
            return Repo(
                rawID: randomID,
                name: randomName,
                fullName: "\(randomOwner.name)/\(randomName)",
                owner: randomOwner,
                starsCount: Int.random(in: 0...10000),
                watchersCount: Int.random(in: 0...5000),
                forksCount: Int.random(in: 0...3000),
                openIssuesCount: Int.random(in: 0...200),
                language: randomLanguage,
                htmlPath: "https://github.com/",
                websitePath: Bool.random() ? "https://\(randomName.lowercased()).com" : nil,
                description: "This is a random repository.",
                subscribersCount: Int.random(in: 0...1000)
            )
        }
        
        static let sampleDataWithLongWord: Repo =
            .init(rawID: 44838949,
                  name: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                  fullName: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                  owner:
                  User(rawID: 10639145,
                       name: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                       avatarImagePath: "https://avatars.githubusercontent.com/u/10639145?v=4",
                       htmlPath: "https://github.com/apple/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"),
                  starsCount: 61080,
                  watchersCount: 2100,
                  forksCount: 9815,
                  openIssuesCount: 6175,
                  language: "C++",
                  htmlPath: "https://github.com/apple/swift/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                  websitePath: "https://www.swift.org/ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                  description: String(repeating: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", count: 5),
                  subscribersCount: 2508)
        
        static let sampleDataWithoutSomeInfo: Repo =
            .init(rawID: 44838949,
                  name: "swift",
                  fullName: "apple/swift",
                  owner:
                  User(rawID: 10639145,
                       name: "apple",
                       avatarImagePath: "https://avatars.githubusercontent.com/u/10639145?v=4",
                       htmlPath: "https://github.com/apple"),
                  starsCount: 61308,
                  watchersCount: 61308,
                  forksCount: 9858,
                  openIssuesCount: 6244,
                  language: nil,
                  htmlPath: "https://github.com/apple/swift",
                  websitePath: nil,
                  description: nil,
                  subscribersCount: 0)
        
        static let sampleDataForReposCellSkelton = Repo(
            rawID: 44838949,
            name: "Lorem ipsum dol",
            fullName: "apple/swift",
            owner:
                User(rawID: 10639145,
                     name: "Lorem ipsum",
                     avatarImagePath: "",
                     htmlPath: "https://github.com/apple"),
            starsCount: 61308,
            watchersCount: 61308,
            forksCount: 9858,
            openIssuesCount: 6244,
            language: "",
            htmlPath: "https://github.com/apple/swift",
            websitePath: "https://swift.org",
            description: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
""",
            subscribersCount: 0
        )
    }
}
