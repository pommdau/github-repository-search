//
//  User.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftID

struct User: Identifiable, Equatable, Sendable & Decodable {
    
    struct ID: StringIDProtocol {
        let rawValue:  String
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    let id: ID
    let name: String
    let avatarImageURL: URL?
    let html: URL?  // e.g. https://github.com/apple
}
